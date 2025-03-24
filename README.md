# allas-cli-utils - Utilities for Allas command line access

The Allas object storage system can be used in multiple ways and for many purposes. 
In many cases, effective usage of Allas requires that the user knows the features of 
both Object Storage systems and the software or protocol that is used to manage data in Allas.

For those users, that just want to use Allas for storing data that is in CSC computing environment, 
CSC provides a set of commands (a-tools ) for moving data between CSC computing environment and Allas.

## Opening connection with allas_conf

Connection configuration tool: allas_conf can be used to configure swift or S3 connections to Allas. 
The tool is designed for linux **bash shell**, that is the default command shell in CSC computing environment.
The basic syntax of this tool for swift protocol is:

```text
   source allas_conf --user your-CSC-user-account
```
and for S3 protocol:
```text
   source allas_conf --mode s3cmd --user your-CSC-user-account
```

After successful connection configuration you can start using tools like, _swift_, _rclone_, _restic_, __A_tools__
or _s3cmd_ to manage data in allas.

## A_ -tools for easy access to Allas

For those users, that just want to use Allas for storing data that is in CSC computing environment, CSC provides a set of commands for managing and moving data between CSC computing environment and Allas.

**Note! since the update done on 1.3. 2022, a-put no longer compresses the uploaded data as a default preprocessing operation. In the future, use option -c in case you want to compress the data before upload.**


## Four main tools for using Allas

|a-command | Function |
| :--- | :--- |
| [a-put](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-put) | Upload a file or directory to Allas as one object |
| [a-get](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-get) | Download a stored dataset (object) from Allas |
| [a-list](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-list) | List buckets and objects in Allas |
| [a-delete](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-delete) | Delete an object from Allas |

## Other tools
The available tools are:
  
|a-command | Function |
| :--- | :--- |
| [a-access](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-access)| Manage access permissions of your buckets in Allas || [a-check](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-check) | Command to check if a-put command was successfully executed |
| [a-check](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-check) | Command to check if a-put command was successfully executed |
| [a-encrypt]() | Make an encrypted copy of an object to make it compatible with CSC sensitive data services | 
| [a-find](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-find)| Search and locate data that has been uploaded with a-put |
| [a-flip](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-flip)| Upload a file to Allas into a bucket that will keep the file temporarily available to the internet |
| [a-info](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-info)| Display information about an object in Allas |
| [a-publish](https://docs.csc.fi/data/Allas/using_allas/a_commands/#a-publish) | Upload a file to Allas into a bucket that allows public access over the internet |



   
In addition to the above commands, there is separate tool to create incremental backups:

*    `allas-backup` : create a backup copy of a local dataset into a backup repository in Allas

And a tool for mounting Allas buckets as directories to a local computer (not yet in production)

*    `allas-mount`

## Installing allas-cli-utils

Allas-cli-utils is mainly designed to be used in the HPC computing environment of CSC.
In CSC computers (Puhti, Mahti ) these tools are installed and maintained by CSC.

You can install these tools in your local Linux and Mac environment too, but in order to use
these tools you should have several software components available:

__allas_conf__ script requires:

*   [bash shell](https://en.wikipedia.org/wiki/Bash_(Unix_shell))
*   [OpenStack client](https://github.com/openstack/python-openstackclient)(3.19 or newer, not mandatory if you use swift and know the project name.)
*   [OpenStack Swift](https://github.com/openstack/swift) and/or [s3cmd](https://s3tools.org/s3cmd) client
, y
I addition to the above, a-tools require:

*   [rclone](https://rclone.org/) (1.48 or newer)
*   [zstdmt](https://github.com/mcmilk/zstdmt)
*   [crypt4gh](https://crypt4gh.readthedocs.io/en/latest/)

If you want to use a-commands to upload or download dara from SD Connect youu need to have *SD lock utils* installed

* [sd-lock-util](https://github.com/CSCfi/sd-lock-util)


Example: Installing allas-cli-utils to a Ubuntu 16.04 server running in cPouta:

```text
#install pip and openstack client
sudo apt install python-pip python-dev
sudo apt-get install python-setuptools
pip install --upgrade pip
pip install python-openstackclient
pip install crypt4gh
pip install s3cmd

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
Example: Installing allas-cli-utils to CentOS 7 based virtual machine in cPouta

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
bash                                      #new session to enable miniconda
git clone https://github.com/CSCfi/allas-cli-utils       #download allas tools
cd allas-cli-utils/
export PATH=${PATH}:$(pwd)
conda create -n allas
conda activate allas
conda install -c conda-forge zstd python pip s3cmd
pip install --upgrade setuptools
pip install python-openstackclient
pip install python-swiftclient
pip install crypt4gh
source allas_conf -u csc-useraccount                     # replace csc-useraccount with your personal CSC account
a-list

```


allas_conf and basic a- commands now support MacOS (but you still must use bash in MacOS to run them). In case md5 cheksum command still fails, there is simple replacement script (md5sum.macosx) that
you can take in use in macs by giving following in the command in the allas-cli-utils directory:
```
mv md5sum.macosx md5sum
```

Example commands in macOS to install python3 libraries in to atools-venv directory for allas-cli-utilities using bash in macOS (note that you also need binaries like rclone and allas-cli-utilities itself from github):
```
python3 -m venv atools-venv
source atools-venv/bin/activate
pip3 install --upgrade pip
pip3 install openstackclient
pip3 install s3cmd
```

Then the "normal" way to start using Allas in macOS in a bash session would be like (exact details would depend on how you want to manage your PATH etc):
```
source atools-venv/bin/activate
source allas_conf
```

## Configuring a-commands

You can define the default settings that the a-tools use in two files: a_env_conf and .a_tools_conf. These settings affect mostly to the a-put data upload command.

### 1. a_env_conf

The file *a_env_conf*, that locates in the installation directory of _allas-cli-utils_, defines some installation specific settings. Users are not able to modify this file in CSC servers (Puhti and Mahti), but this file includes settings that you  want to change if you do a local allas-cli-utils installation. 

   * _allas_conf_path_ should define the location of _allas_conf_ script in your system.
   * You may also want to change _tmp_root_ definition if you want use some other location than /tmp for temporary tiles.

### 2. .a_tools_conf

A user can define her own default settings for a-commands by making a configuration file named as **.a_tools_conf** to her **home directory**. These user specific settings can be done as well at the CSC servers too. In this file you can set default values for many of the functions that are defined with a-put command options.

For example, if you are uploading files that would benefit from compression, you could use _--compress_ option with a-put. If you want this to be default setting you could create .a_tools_conf file
that contains setting:

```text
compression=1
```
Now command:
```text
a-put my_data.b
```
Will compress the data during the upload process. However, you can still skip the compression with option _--nc_.

```text
a-put --nc my_data.b
```
You can check most commonly used settings from this sample [.a_tools_conf](./.a_tools_conf) file. Copy the sample file to your home directory and uncomment and define the variables you wish to use.






