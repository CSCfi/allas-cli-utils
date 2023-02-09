# lumio-cli-utils - Utilities for LUMI-O command line access

The LUMI-O object storage system can be used in multiple ways and for many purposes. 
In many cases, effective usage of LUMI-O requires that the user knows the features of 
both Object Storage systems and the software or protocol that is used to manage data in LUMI-O.

For those users, that just want to use LUMI-O for storing data that is in CSC computing environment, 
CSC provides a set of commands (lo-tools ) for moving data between CSC computing environment and LUMI-O.

## Opening connection with lumio_conf

Connection configuration tool: lumio_conf can be used to configure swift or S3 connections to LUMI-O. 
The tool is designed for linux **bash shell**, that is the default command shell in CSC computing environment.
The basic syntax of this tool for swift protocol is:

```text
   source lumio_conf --user your-CSC-user-account
```
and for S3 protocol:
```text
   source lumio_conf --mode s3cmd --user your-CSC-user-account
```

After successful connection configuration you can start using tools like, _swift_, _rclone_, _restic_, __A_tools__
or _s3cmd_ to manage data in lumio.

## A_ -tools for easy access to LUMI-O

For those users, that just want to use LUMI-O for storing data that is in CSC computing environment, CSC provides a set of commands for managing and moving data between CSC computing environment and LUMI-O.

**Note! since the update done on 1.3. 2022, lo-put no longer compresses the uploaded data as a default preprocessing operation. In the future, use option -c in case you want to compress the data before upload.**


## Four main tools for using LUMI-O

|lo-command | Function |
| :--- | :--- |
| [lo-put](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-put) | Upload a file or directory to LUMI-O as one object |
| [lo-get](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-get) | Download a stored dataset (object) from LUMI-O |
| [lo-list](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-list) | List buckets and objects in LUMI-O |
| [lo-delete](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-delete) | Delete an object from LUMI-O |

## Other tools
The available tools are:
  
|lo-command | Function |
| :--- | :--- |
| [lo-access](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-access)| Manage access permissions of your buckets in LUMI-O || [lo-check](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-check) | Command to check if lo-put command was successfully executed |
| [lo-check](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-check) | Command to check if lo-put command was successfully executed |
| [lo-encrypt]() | Make an encrypted copy of an object to make it compatible with CSC sensitive data services | 
| [lo-find](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-find)| Search and locate data that has been uploaded with lo-put |
| [lo-flip](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-flip)| Upload a file to LUMI-O into a bucket that will keep the file temporarily available to the internet |
| [lo-info](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-info)| Display information about an object in LUMI-O |
| [lo-publish](https://docs.csc.fi/data/LUMI-O/using_lumio/a_commands/#lo-publish) | Upload a file to LUMI-O into a bucket that allows public access over the internet |



   
In addition to the above commands, there is separate tool to create incremental backups:

*    `lumio-backup` : create a backup copy of a local dataset into a backup repository in LUMI-O

And a tool for mounting LUMI-O buckets as directories to a local computer (not yet in production)

*    `lumio-mount`

## Installing lumio-cli-utils

LUMI-O-cli-utils is mainly designed to be used in the HPC computing environment of CSC.
In CSC computers (Puhti, Mahti ) these tools are installed and maintained by CSC.

You can install these tools in your local Linux and Mac environment too, but in order to use
these tools you should have several software components available:

__lumio_conf__ script requires:

*   [bash shell](https://en.wikipedia.org/wiki/Bash_(Unix_shell))
*   [OpenStack client](https://github.com/openstack/python-openstackclient)(3.19 or newer, not mandatory if you use swift and know the project name.)
*   [OpenStack Swift](https://github.com/openstack/swift) and/or [s3cmd](https://s3tools.org/s3cmd) client

I addition to the above, A_ -tools require:

*   [rclone](https://rclone.org/) (1.48 or newer)
*   [zstdmt](https://github.com/mcmilk/zstdmt)
*   [crypt4gh](https://crypt4gh.readthedocs.io/en/latest/)


Example: Installing lumio-cli-utils to a Ubuntu 16.04 server running in cPouta:

```text
#install pip and openstack client
sudo apt install python-pip python-dev
sudo apt-get install python-setuptools
pip install --upgrade pip
pip install python-openstackclient
pip install crypt4gh

#install swift client
sudo apt install python3-swiftclient
curl https://rclone.org/install.sh | sudo bash
git clone https://github.com/CSCfi/lumio-cli-utils
cd  lumio-cli-utils/
export PATH=${PATH}:$(pwd)
```

Example: Installing lumio-cli-utils to Ubuntu 18.04 so that conda is used in the installation of dependencies.


```text
sudo apt-get update
sudo apt-get install gcc
sudo apt-get install restic
curl https://rclone.org/install.sh | sudo bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh 
bash
git clone https://github.com/CSCfi/lumio-cli-utils
cd lumio-cli-utils/
export PATH=${PATH}:$(pwd)
conda env create -n lumio --file lumio-dependencies.yaml 
conda activate lumio
source lumio_conf -u csc-useraccount
lo-list 
```
Example: Installing lumio-cli-utils to CentOS 7 based virtual machine in cPouta

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
git clone https://github.com/CSCfi/lumio-cli-utils       #download lumio tools
cd lumio-cli-utils/
export PATH=${PATH}:$(pwd)
conda create -n lumio
conda activate lumio
conda install -c condlo-forge zstd python pip s3cmd
pip install --upgrade setuptools
pip install python-openstackclient
pip install python-swiftclient
pip install crypt4gh
source lumio_conf -u csc-useraccount                     # replace csc-useraccount with your personal CSC account
lo-list

```


In MacOS X systems md5sum command may be missing. To fix that, there is simple replacement script (md5sum.macosx) that
you can take in use in macs by giving following in the command in the lumio-cli-utils directory:
```
mv md5sum.macosx md5sum
```

## Configuring lo-commands

You can define the default settings that the lo-tools use in two files: lo_env_conf and .a_tools_conf. These settings affect mostly to the lo-put data upload command.

### 1. lo_env_conf

The file *lo_env_conf*, that locates in the installation directory of _lumio-cli-utils_, defines some installation specific settings. Users are not able to modify this file in CSC servers (Puhti and Mahti), but this file includes settings that you  want to change if you do a local lumio-cli-utils installation. 

   * _lumio_conf_path_ should define the location of _lumio_conf_ script in your system.
   * You may also want to change _tmp_root_ definition if you want use some other location than /tmp for temporary tiles.

### 2. .a_tools_conf

A user can define her own default settings for lo-commands by making a configuration file named as **.a_tools_conf** to her **home directory**. These user specific settings can be done as well at the CSC servers too. In this file you can set default values for many of the functions that are defined with lo-put command options.

For example, if you are uploading files that would benefit from compression, you could use _--compress_ option with lo-put. If you want this to be default setting you could create .a_tools_conf file
that contains setting:

```text
compression=1
```
Now command:
```text
lo-put my_data.b
```
Will compress the data during the upload process. However, you can still skip the compression with option _--nc_.

```text
lo-put --nc my_data.b
```
You can check most commonly used settings from this sample [.a_tools_conf](./.a_tools_conf) file. Copy the sample file to your home directory and uncomment and define the variables you wish to use.






