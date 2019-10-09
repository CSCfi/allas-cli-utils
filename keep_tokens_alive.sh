#!/bin/bash 

#
# this script keeps allas tokens fresh
# 

if [[ $1 == "" ]]; then
  echo "Please give encryption password as the first argument"
fi 

if [[ $2 == "" ]]; then  
  echo "Please give file name for encrypted token as the second argument"
fi 



enc_key=$1
fname=$2
master_process=$3


#constants
limit=(1700000)
#interval=(20)
interval=(7200)
sofar=(0)
#location=(/tmp)
OS_AUTH_URL='https://pouta.csc.fi:5001/v3/auth/tokens'
TOKEN_HEADER_RE='^X-Subject-Token: '
PROJECT_ID_SED='s+^https://object.pouta.csc.fi:443/swift/v[1-9]/AUTH_\([A-Za-z0-9]*\)$+\1+'

echo "testing connection"
#Check that we have a valid token
test=$(swift stat 2> /dev/null | grep -c "Account:")
if [[ $test -lt 1 ]]
then 
  echo "No connection to Allas!"
  echo "Please try setting the the connection again."
  echo "by running command:"
  echo ""
  echo "   source /appl/opr/allas_conf"
  exit 1 
else
  echo "connection OK"
fi



# refresh current tokens
while [[ $sofar -lt $limit ]];
do
  

  if [ -n "$master_process" ]; then 
    if ps -p $master_process > /dev/null
    then 
      echo "master process running"
    else
      rm -f ${fname}
      exit 0
    fi
  fi 

#  # echo "While $sofar"
#  #echo "variables:"
#  #echo $OS_AUTH_TOKEN
#  #echo $OS_STORAGE_URL
#
#  #echo "updating"
#  #source /appl/opt/allas-cli-utils/object-pouta-token2token
# 
#  echo debug1
#  OS_PROJECT_ID=`echo "$OS_STORAGE_URL" | sed "$PROJECT_ID_SED"`
#
#  OS_AUTH_TOKEN_DATA='{ "auth": { "identity": { "methods": [ "token" ], "token": { "id": "'$OS_AUTH_TOKEN'" }
#                     }, "scope": { "project": { "id": "'$OS_PROJECT_ID'" } } } } '
#  echo debug2
#  # authenticate and get return values
#  echo "curl -sS -X POST -D - -d \'@-\' -H \'Content-Type: application/json\' \"$OS_AUTH_URL\" '<<<' \"$OS_AUTH_TOKEN_DATA\" "
#  OUT=`curl -sS -X POST -D - -d '@-' -H 'Content-Type: application/json' "$OS_AUTH_URL" 2>&1 <<< "$OS_AUTH_TOKEN_DATA"`
#  CURL_EXIT="$?"
#  STATUS=`echo "$OUT" | grep '^HTTP/1.1 201 Created' | wc -l | tr -d ' '`
#  if [ "$CURL_EXIT" != "0" -o "$STATUS" != "1" ]; then
#         echo "eka osa"
#         echo "FAILED" >&2
#         echo "$OUT" | grep -E '^HTTP|{|}|^curl:' >&2
#  else
#       export OS_AUTH_TOKEN=`echo "$OUT"|tr -d '\r'|grep "$TOKEN_HEADER_RE"|sed "s/$TOKEN_HEADER_RE//"`
#  fi 
#
#  echo debug3

  export OS_AUTH_TOKEN=$(allas-token2token) 

  echo $OS_AUTH_TOKEN | openssl enc -aes-256-cbc -k $enc_key -out ${fname}
  
  # echo "OS_AUTH_TOKEN  updated in ${fname}"

  sleep $interval
  
  (( sofar = sofar + $interval ))

done
