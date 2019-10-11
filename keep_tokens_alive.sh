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
interval=(3600)
#interval=(7200)
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

old_token=$OS_AUTH_TOKEN

# refresh current tokens
while [[ $sofar -lt $limit ]];
do
  

  if [ -n "$master_process" ]; then 
    if ps -p $master_process > /dev/null
    then 
      echo "master process running"
    else
      rm -f ${fname} ${fname}_proc
      exit 0
    fi
  fi 

  new_token=$(allas-token2token $old_token)
  old_token=$new_token
  #unset OS_AUTH_TOKEN
  #export OS_AUTH_TOKEN=$new_token

  #echo $OS_AUTH_TOKEN | openssl enc -aes-256-cbc -k $enc_key -out ${fname}
  echo $new_token | openssl enc -aes-256-cbc -k $enc_key -out ${fname}
  echo $$ > ${fname}_proc
  # echo "OS_AUTH_TOKEN  updated in ${fname}"

  sleep $interval
  
  (( sofar = sofar + $interval ))

done
