# lo-put
 
```text
This tool is used to upload data from the disk environment 
of CSC's supercomputers to LUMI-O and Lumi-o storage environments. 
lo-put can be used in other environments too.

The basic syntax of the command is:

   lo-put directory_or_file

By default this tool performs following operations:

1. Ensures that you have working connection to the storage 
   service.

2. In case of directory, the content of the directory is 
   collected into a single file (using tar command).

3. By default the data is uploaded to LUMI-O using rclone command 
   and swift protocol. Lumi-o and LUMI-O with S3 protocol is available too.

NOTE! Data was compression with zstdmt command is no longer done by 
default before the upload.


The location were data is stored in the storage server (LUMI-O or Lumi-o) can be defined with 
options --bucket (-b) and --object (-o).

The default option is that data that locates in: 
  - scratch in Puhti is uploaded to bucket:  project_number-puhti-SCRATCH
  - scratch in Mahti is uploaded to bucket:  project_number-mahti-SCRATCH
  - projappl in Puhti is uploaded to bucket:  project_number-puhti-PROJAPPL
  - projappl in Mahti is uploaded to bucket:  project_number-mahti-PROJAPPL
  - LOCAL_SCRATCH in Puhti is uploaded to bucket: project_number-puhti-LOCAL_SCRATCH
  - project in Lumi is uploaded to bucket:  project_number-lumi-o-project
  - flash in Lumi is uploaded to bucket:  project_number-lumi-o-flash
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
   lo-put test_1.txt

In this case the file is stored to bucket: 201234-puhti-SCRATCH
as object: test_1.txt.zst

If you have another file called test_1.txt that locates in directory 
/scratch/project_201234/project2/sample3 you can store it with commands:
   
  cd /scratch/project_201234/project2/sample3
  lo-put test_1.txt
  
Or commands
  cd /scratch/project_201234
  lo-put project2/sample3/test_1.txt

In these cases the file is stored to bucket: 201234-puhti-SCRATCH
as object:  project2/sample3/test_1.txt.zst


lo-put command line options:

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
                            contains large amount of files. However, lo-find 
                            can't be used to locate objects uploaded this way.

--no-ometa                  Don't create metadata objects ( _ometa ) for the 
                            stored data objects.

-m, --message "your notes"  Add a one line text note to the metadata object.

--override                  Allow overwriting existing objects.

--input-list <list_file>    Give a file that lists the files or directories 
                            to be uploaded to LUMI-O. Each item will be stored as one object.

-a, --asis                  Copy the given file or content of a directory to LUMI-O
                            without compression and packing so that each file in the 
                            directory will be copied to LUMI-O as an individual object.
                            The object name contains the relative path of the file to 
                            be copied. 

--follow-links              When uploading a directory, include linked files as real files
                            instead of links.

-e, --encrypt <method>      Options: gpg and c4gh. Encrypt data with gpg or crypt4gh.

--pk, --public-key          Public key used for crypt4gh encryption.

--sdx                       Upload data to LUMI-O in format format that is compatible with
                            the CSC Sensitive data services: The files are encrypted with 
                            crypt4gh using CSC public key after which the files are imported 
                            to LUMI-O. 
                            With --public-key you can do the encryption with both
                            CSC and your own public key. By default data is stored to bucket with name:
                            your-project-number_SD-CONNECT.


-A, --lumio                     Upload data to LUMI-O with swift protocol in stead of currently set storage server. 
                            Normally this (LUMI-O with swift) is the default and this option is not needed,
                            but if you have set e.g. Lumi-O as the default storage server, this option can be
                            used to upload data to LUMI-O without changing the default storage server.
                              
--s3cmd                     Use LUMI-O with S3 protocol.

-L, --lumi                      Upload data to Lumi-O with S3 protocol in stead of the default storage server. 
                            If Lumi-O is defined to be the default storage server and this option is not needed.

Related commands: lo-find, lo-get, lo-delete, lo-info
```
