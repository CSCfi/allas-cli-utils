#!/usr/bin/env bash

# Script expects a sourced Openstack project (openrc) file and configured
# rclone remote for Swift

# Script expects rclone remote for swift object store in $RCLONE_DESTINATION
RCLONE_DESTINATION=allas

# Can configure maximum simultaneous uploads in $MAX_PROCESSES environment
# variable – recommended is amount of threads

# $1 is the file to be copied, $2 is the destination container

# Get the openstack authentication token
OS_AUTH_TOKEN=$(openstack token issue -f value | sed -n 2p)
OS_AUTH_URL="https://pouta.csc.fi:5001/v3"

# Get Openstack swift URL

#echo "Debug: Start"
 
SWIFT_URL=$(curl $OS_AUTH_URL/auth/catalog -s -X GET -H "X-Auth-Token: $OS_AUTH_TOKEN" \
    | jq ".catalog" \
    | jq -c '.[] | select(.type == "object-store")' \
    | jq -r ".endpoints[2].url")

#echo "Debug $SWIFT_URL"

set -m; # Enable job control

upload_segment() {
    echo "   Starting to upload segment $1/$3"
    # Using 5GiB segments as specified by Openstack Swift protocol
    # Using Openstack tools naming scheme for segments and containers
    # Using 1MiB block size for dd

    # $1 is the file to be uploaded, # $2 is the destination container, 
    # $3 is the index, $4 the timestamp, $5 the filesize
    #echo "dd status=none if=$1 bs=1M count=5120 skip=$(echo "5120 * $3" | bc) "
    #echo "rclone --swift-no-chunk rcat $RCLONE_DESTINATION:$2_segments/$1/$4/$5/$(printf "%08d" $3)"
    dd status=none if=$1 bs=1M count=5120 skip=$(echo "5120 * $3" | bc) \
        | rclone --swift-no-chunk rcat $RCLONE_DESTINATION:$2_segments/$1/$4/$5/$(printf "%08d" $3)
    echo "   Segment $1/$3 ready"
};



upload_segment_md5() {
    echo "   Starting to upload a segment $1/$3"
    # Using 5GiB segments as specified by Openstack Swift protocol
    # Using Openstack tools naming scheme for segments and containers
    # Using 1MiB block size for dd

    # $1 is the file to be uploaded, # $2 is the destination container,
    # $3 is the index, $4 the timestamp, $5 the filesize
    #echo "dd status=none if=$1 bs=1M count=5120 skip=$(echo "5120 * $3" | bc) "
    #echo "rclone --swift-no-chunk rcat $RCLONE_DESTINATION:$2_segments/$1/$4/$5/$(printf "%08d" $3)"
    local skipvalue=$(echo "5120 * $3" | bc)
    local s_kesto=0
    local s_alku=$(date +%s)
    local do_upload=1
    local s_loppu=$(date +%s)
    local ite=0
    while [[ $do_upload -eq 1 ]]; do
      s_alku=$(date +%s)
      dd status=none if=$1 bs=1M count=5120 skip=$(echo "5120 * $3" | bc) \
        | rclone --swift-no-chunk rcat $RCLONE_DESTINATION:$2_segments/$1/$4/$5/$(printf "%08d" $3)
    
      s_loppu=$(date +%s)
      (( s_kesto = s_loppu - s_alku ))
      echo "   Segment upload $1/$3 ready in $s_kesto seconds"
      echo "     Calculating md5 sums for $1/$3"
      s_alku=$(date +%s)
      local md5string=$(dd status=none if=$1 bs=1M count=5120 skip=$skipvalue | md5sum - | awk '{print $1}')
      local md5allas=$(rclone md5sum $RCLONE_DESTINATION:$2_segments/$1/$4/$5/$(printf "%08d" $3) | awk '{print $1}')
      s_loppu=$(date +%s)
      (( s_kesto = s_loppu - s_alku ))
      if [[ "$md5string" == "$md5allas" ]]; then
         echo "     Checksums match for $1/$3. Checking took $s_kesto seconds."
         echo "   Segment $1/$3 ready."
         do_upload=0	 
      else
         echo "ERROR: for $1/$3."
         echo "Local and Allas checksums don't match"
         rclone delete  $RCLONE_DESTINATION:$2_segments/$1/$4/$5/$(printf "%08d" $3)
         ((ite = ite + 1 ))
         if [[ $ite -lt 3 ]]; then
            echo "Retrying failed segment upload."
         else
            echo "Too many failed upload attempts."
            do_upload=0
         fi
      fi
   done
};


push_manifest() {
    echo "   Push Openstack Swift DLO manifest"    
    curl -s -X PUT "$SWIFT_URL/${2}/${1}" \
        -H "X-Auth-Token: $OS_AUTH_TOKEN" \
        -H "X-Object-Manifest: ${2}_segments/${1}/${3}/${4}" \
        --data-binary '' \
    && echo "${1}"
}

timestamp=$(date +%s);
filesize=$(stat --printf="%s" $1);
check_md5=$3

# skip files < 5GiB – we have tools for those
if [[ $filesize -le 5368709120 ]]; then
    echo "Use ordinary rclone for files smaller than 5GiB, or use concurrent_rclone_copy for uploading multiple files concurrently"
    exit
fi

# Configure maximum simultaneous uploads
if [[ -z $RCLONE_DESTINATION ]]; then
    RCLONE_DESTINATION=allas
fi



# Configure maximum simultaneous uploads
if [[ -z $MAX_PROCESSES ]]; then
    MAX_PROCESSES=4
fi

for ((i = 0; i * 5368709120 < $filesize; i++)); do
    # Throttle opening too many jobs, with ugly busywaiting
    while [[ $(jobs -p |wc -l) -ge $MAX_PROCESSES ]]; do
        sleep 5
    done
    if [[ $check_md5 -eq 1 ]]; then
       upload_segment_md5 $1 $2 $i $timestamp $filesize &  # fork a new process for each segment
    else 
       upload_segment $1 $2 $i $timestamp $filesize &
    fi
done

# Wait for all parallel jobs to finish – this method of waiting allows for using ctrl-z as well, if need be
while [[ -n $(jobs -r) ]]; do 
    sleep 5; 
done


push_manifest $1 $2 $timestamp $filesize
