#!/bin/bash

storage_server=$1
bucket_name=$2
mount_point=$3
mode=$4

if [[ $(echo $OSTYPE | grep -i -c linux) -eq 1 ]]; then
   umount_command="fusermount -u $mount_point"
else
   umount_command="umount $mount_point"
fi 
trap "$umount_command" EXIT
rclone mount ${storage_server}:$bucket_name $mount_point $mode

exit

#
#
#n=1
#while  [ $n -gt 1 ]
#do
#  sleep 30
#  n=$(rclone about $storage_server | wc -l)
#done
