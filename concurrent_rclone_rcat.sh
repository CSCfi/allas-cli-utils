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
    upload_segment $1 $2 $i $timestamp $filesize &  # fork a new process for each segment
done

# Wait for all parallel jobs to finish – this method of waiting allows for using ctrl-z as well, if need be
while [[ -n $(jobs -r) ]]; do 
    sleep 5; 
done


push_manifest $1 $2 $timestamp $filesize
