# allas-cli-utils - Utilities for Allas command line access

The Allas object storage system can be used in multiple ways and for many purposes. 
In many cases, effective usage of Allas requires that the user knows the features of 
both Object Storage systems and the software or protocol that is used to manage data in Allas.

For those users, that just want to use Allas for storing data that is in CSC computing environment, 
CSC provides a set of commands (a_ tools ) for moving data between CSC computing environment and Allas.

## Opening connection with allas_conf

Connection configuration tool: allas_conf can be used to configure swift or s3cmd connections to Allas. 
The basic syntax of this tool is

```text
   source allas_conf --user your-CSC-user-account
```

After successfull connection configuration you can start using tools like, _swift_, _rclone_, _restic_, __A_tools__
or _s3cmd_ to manage data in allas.

## A_ -tools for easy access to Allas

For those users, that just want to use Allas for storing data that is in CSC computing environment, CSC provides a set of commands for managing and moving data between CSC computing environment and Allas. The available tools are:
  
|a_command | Function |
| :--- | :--- |
| a_put | Upload a file or directory to Allas as one object |
| a_list | List buckets and objects in Allas |
| a_publish | Upload a file to Allas into a bucket that allows public access over the internet |
| a_get | Download a stored dataset (object) from Allas |
| a_find | Search and locate data that has been uploaded with a_put |
| a_delete | Delete an object from Allas |
| a_info | Display information about an object in Allas |
   
In addition to the above command, there is saparate tool to create incremental backups:

*    `a_backup` : create a backup copy of a local dataset into a backup repository in Allas


## Installing allas-cli-utils

Allas-cli-utils is mainly designed to be used in the HPC computing environmemt of CSC.
In CSC computers (Puhti, Mahti, Taito) these tools are installed and maintained by CSC.

You can install these tools in your local Linux and Mac environment too, but in order to use
these tools you should have several software componets available:

__allas_conf__ script requires:

*   OpenStack client (3.19 or newer)
*   swift and/or s3cmd client

I addition to the above, A_ -tools requre:

*   rclone (1.48 or newer)
*   zstdmt


Exaple: Installing allas-cli-utils to a Ubuntu 16.04 server running in cPouta:

```text
#install pip and openstack client
sudo apt install python-pip python-dev
sudo apt-get install python-setuptools
sudo pip install --upgrade pip
sudo pip install python-openstackclient

#install swift client
sudo apt install python3-swiftclient
curl https://rclone.org/install.sh | sudo bash
git clone https://github.com/CSCfi/allas-cli-utils
cd  allas-cli-utils/
export PATH=${PATH}:$(pwd)
```
 
