# allas-dir-to-bucket
 
```text

DESCRIPTION

This tool is used to upload on content of a directory or a file to a bucket in
Allas. Upload is done with rclone. 

The upoload is done so that the content between the source directory in your local 
computer and the target bucket in Allas is synchronized. This means that in addition to 
copying data from the local directory to the bucket in Allas, the objects 
in Allas, that don't match files in the local directory, are removed.

Because of that you should mainly use this tool to upoload data to
a new empty bucket in Allas. If the target bucket does not exist, it will be 
automatically created.
 
In Allas, files larger than 5 GiB will be stored as 5GiB segments. 
This tool utilizes this segmentation to speed up the upload process 
by uploading several segments of a large file simultaneously.
Smaller files will be uploaded using normal rclone copy command.

USAGE

The basic syntax of the command is:

   allas-dir-to-bucket source-directory  target-bucket

You can also define source directory and target bucket with 
command line options.

The files will be uploaded to the defined bucket and the object names 
will include the source direcrtory name. For example if we have a directory
"data1" containing files sample_1.dat and sample_2.dat, then command:
  
  allas-dir-to-bucket data1  p20001234_backup

Will create bucket:
 
   p20001234_backup

That contains objects:
   
  data1/sample_1.dat
  data1/sample_2.dat

  
COMMAND LINE OPTIONS

allas-dir-to-bucket command line options:

-d, --directory' <dir_name> Name of the directory or file to be uploaded to Allas.

-b, --bucket <bucket_name>  Define a name of the bucket into 
                            which the data is uploaded.

-s, --stream <number>         Number of simultaneous upload streams.
                            Default 4.

-m, --md5                   Check md5 sums of uploaded segments.

-u, --user <csc-user-name>  Define username liked to the data to be uploaded
                            (default: current username).

-h, --help                  Print this help.
 
OS_PASSWORD not defned!
allas-dir-to-bucket needs to have your Allas password stored in an environment variable.
Please setup you Allas connection with a command that sets this variable.

 In Puhti and Mahti use:
      allas-conf -k

 In Other servers use: 
      source allas_conf -k -u <your-csc-user-account>
```
