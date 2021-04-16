# allas-cli-utils - Utilities for Allas command line access

The Allas object storage system can be used in multiple ways and for many purposes. 
In many cases, effective usage of Allas requires that the user knows the features of 
both Object Storage systems and the software or protocol that is used to manage data in Allas.

For those users, that just want to use Allas for storing data that is in CSC computing environment, 
CSC provides a set of commands (a- tools ) for moving data between CSC computing environment and Allas.

## Opening connection with allas_conf

Connection configuration tool: allas_conf can be used to configure swift or s3cmd connections to Allas. 
The basic syntax of this tool for swift protocol is

```text
   source allas_conf --user your-CSC-user-account
```
and for S3 protocol:
```text
   source allas_conf --mode s3cmd --user your-CSC-user-account
```

After successfull connection configuration you can start using tools like, _swift_, _rclone_, _restic_, __A_tools__
or _s3cmd_ to manage data in allas.

## A_ -tools for easy access to Allas

For those users, that just want to use Allas for storing data that is in CSC computing environment, CSC provides a set of commands for managing and moving data between CSC computing environment and Allas. The available tools are:
  
|a-command | Function |
| :--- | :--- |
| a-put | Upload a file or directory to Allas as one object |
| a-get | Download a stored dataset (object) from Allas |
| a-list | List buckets and objects in Allas |
| a-delete | Delete an object from Allas |
| a-check | Command to check if a-put command was successfully executed |
| a-publish | Upload a file to Allas into a bucket that allows public access over the internet |
| a-flip | Upload a file to Allas into a bucket that will keep the file temporarily available to the internet |
| a-find | Search and locate data that has been uploaded with a-put |
| a-info | Display information about an object in Allas |
| a-access | Manage access permissions of your bucktes in Allas |
   
In addition to the above commands, there is saparate tool to create incremental backups:

*    `allas-backup` : create a backup copy of a local dataset into a backup repository in Allas

And a tool for mounting Allas buckets as directores to a local computer (not yet in production)

*    `allas-mount`

## Installing allas-cli-utils

Allas-cli-utils is mainly designed to be used in the HPC computing environmemt of CSC.
In CSC computers (Puhti, Mahti ) these tools are installed and maintained by CSC.

You can install these tools in your local Linux and Mac environment too, but in order to use
these tools you should have several software componets available:

__allas_conf__ script requires:

*   [OpenStack client](https://github.com/openstack/python-openstackclient)(3.19 or newer, not mandatory if you use swift and know the project name.)
*   [OpenStack Swift](https://github.com/openstack/swift) and/or [s3cmd](https://s3tools.org/s3cmd) client

I addition to the above, A_ -tools requre:

*   [rclone](https://rclone.org/) (1.48 or newer)
*   [zstdmt](https://github.com/mcmilk/zstdmt)


Example: Installing allas-cli-utils to a Ubuntu 16.04 server running in cPouta:

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

Example: Installing allas-cli-utils to Ubuntu 18.04 so that conda is used in the installation of dependencies.


```text
sudo apt-get update
sudo apt-get install gcc
sudo apt-get install restic
curl https://rclone.org/install.sh | sudo bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh 
bash
git clone https://github.com/CSCfi/allas-cli-utils
cd allas-cli-utils/
export PATH=${PATH}:$(pwd)
conda env create -n allas --file allas-dependencies.yaml 
conda activate allas
source allas_conf -u csc-useraccount
a-list 
```
Example: Installing allas-cli-utils to Centos 7 based virtual machine in cPouta

```text
sudo yum update                          # update everything first
sudo yum install unzip                   # install rclone
curl https://rclone.org/install.sh | sudo bash                
sudo yum install yum-plugin-copr         # three commands to install restic
sudo yum copr enable copart/restic
sudo yum install restic
# install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
bash                                      #new sesion to enable miniconda
git clone https://github.com/CSCfi/allas-cli-utils       #download allas tools
cd allas-cli-utils/
export PATH=${PATH}:$(pwd)
conda create -n allas
conda activate allas
conda install -c conda-forge zstd python pip s3cmd
pip install --upgrade setuptools
pip install python-openstackclient
pip install python-swiftclient    
source allas_conf -u csc-useraccount                     # replace csc-useraccount with your personal CSC account
a-list

```


In MacOSX systems md5sum command may be missing. To fix that, there is simple replacement script (md5sum.macosx) that
you can take in use in macs by giving following in the command in the allas-cli-utils directory:
```
mv md5sum.macosx md5sum
```

## Configuring a-commands

You can define the default settings that the a-tools use in two files: a_env_conf and .a_tools_cond. These settings affect mostly to the a-put data upload command.

### 1. a_env_conf

The file *a_env_conf*, that locates in the installation directory of _allas-cli-utils_, defines some installation specific settings.
Users are not able to modify this file in CSC servers (Puhti and Mahti), but this file includes settings that you may want to change if you
do a local allas-cli-utils installation. You may for example change _tmp_root_ definion if you want use some other location than /tmp for temporary tiles.

### 2. .a_tools_conf

A user can define her own default settings for a-commands by making a configuration file named as **.a_tools_conf** to her **home directory**. These user specific settings can be done as well at the CSC servers too. In this file you can set default values for many of the functions that are be defined with a-put command options.

For example, if you are working with files that do not benefit from compression, you could skip the compression.
You can do this by using the _--nc_ option with a-put, but if you want this to be default setting you could create .a_tools_conf file
that contains setting:

```text
compression=0 
```
No now command:
```text
a-put my_data.b
```
Will not compress the data during the upload process. Howerer, you can still use compression with option _--compress_.

```text
a-put --compress my_data.b
```
You can check most commonly used settings from this sample [.a_tools_conf](./.a_tools_conf) file. Copy the sample file to your home directory and un-comment and define the variables you wish to use.






