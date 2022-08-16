# a-put
 
```text
This tool is used to upload data from the disk environment 
of CSC's supercomputers to Allas storage environment. 
a-put can be used in other environments too.

The basic syntax of the command is:

   a-put directory_or_file

By default this tool performs following operations:

1. Ensures that you have working connection to Allas storage 
   service.

2. In case of directory, the content of the directory is 
   collected into a single file (using tar command).

3. By default the data is uploaded to Allas using rclone command 
   and swift protocol. S3 protocol is available too.

NOTE! Data was compression with zstdmt command is no longer done by 
default before the upload.


The location were data is stored in Allas can be defined with 
options --bucket (-b) and --object (-o).

The default option is that data that locates in: 
  - scratch in Puhti is uploaded to bucket:  project_number-puhti-SCRATCH
  - scratch in Mahti is uploaded to bucket:  project_number-mahti-SCRATCH
  - projappl in Puhti is uploaded to bucket:  project_number-puhti-PROJAPPL
  - projappl in Mahti is uploaded to bucket:  project_number-Mahti-PROJAPPL
  - LOCAL_SCRATCH in Puhti is uploaded to bucket: project_number-puhti-LOCAL_SCRATCH

In other cases the data uploaded to by default : username-project_number-MISC

For example for user kkaytaj belonging in project_201234, data 
locating in home directory will be uploaded to bucket:  kkayttaj-201234-MISC.

The compressed dataset will be stored as one object. The object 
name depends on the file name and location. The logic used is that 
the possible sub-directory path in Mahti or Puhti is included 
in the object name. 

E.g. a file called test_1.txt in scratch directory of Puhti can be 
stored with commands:

   cd /scratch/project_201234
   a-put test_1.txt

In this case the file is stored to bucket: 201234-puhti-SCRATCH
as object: test_1.txt.zst

If you have another file called test_1.txt that locates in directory 
/scratch/project_201234/project2/sample3 you can store it with commands:
   
  cd /scratch/project_201234/project2/sample3
  a-put test_1.txt
  
Or commands
  cd /scratch/project_201234
  a-put project2/sample3/test_1.txt

In these cases the file is stored to bucket: 201234-puhti-SCRATCH
as object:  project2/sample3/test_1.txt.zst


a-put command line options:

-b, --bucket <bucket_name>  Define a name of the bucket into 
                            which the data is uploaded.

-p, --project <project_ID>  Upload data into buckets of the defined 
                            project instead of the currently 
                            configured project.

-o, --object <object_name>  Define a name for the new object to be 
                            created.

-S, --s3cmd                 Use S3 protocol instead of swift protocol 
                            for upload.

-n, --nc                    Do not compress the data that will be uploaded.
                            (This is now the default mode thus this option is 
                            no longer needed).

-c, --compress              The data is compressed using zstdmt command before
                            upload. 
 
-h, --help                  Print this help.

-t, --tmpdir                Define a directory that will be used to store 
                            temporary files of the upload process.

-s, --silent                Less output

-u, --user                  Define username liked to the data to be uploaded
                            (default: current username)

--skip-filelist             Do not collect information about the files that 
                            the object contains to the metadata file.
                            Using this option speeds up the upload process 
                            significantly if the directory to be uploaded 
                            contains large amount of files. However, a-find 
                            can't be used to locate objects uploaded this way.

--no-ameta                  Don't create metadata objects ( _ameta ) for the 
                            stored data objects.

-m, --message "your notes"  Add a one line text note to the metadata object.

--override                  Allow overwriting existing objects.

--input-list <list_file>    Give a file that lists the files or directories 
                            to be uploaded to Allas. Each item will be stored as one object.

-a, --asis                  Copy the given file or content of a directory to Allas
                            without compression and packing so that each file in the 
                            directory will be copied to Allas as an individual object.
                            The object name contains the relative path of the file to 
                            be copied. 

--follow-links              When uploading a directory, include linked files as real files
                            instead of links.

-e, --encrypt <method>      Options: gpg and c4gh. Encrypt data with gpg or crypt4gh.

--pk, --public-key          Public key used for crypt4gh encryption.

--sdx                       Upload data to Allas in format format that is compatible with
                            the CSC Sensitive data services: The files are encrypted with 
                            crypt4gh using CSC public key after which the files are imported 
                            to Allas. 
                            With --public-key you can do the encryption with both
                            CSC and your own public key. By default data is stored to bucket with name:
                            your-project-number_SD-CONNECT,


Related commands: a-find, a-get, a-delete, a-info
```
