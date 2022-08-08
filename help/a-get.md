# a-get
 
```text
This tool is used to download data that has been uploaded to Allas service using the a-put command.
The basic syntax of the command is:

   a-get object_name

By default the object is retrieved and uncompressed 

Options:

-p, --project <project_ID>    Search matches form the buckets of the defined project instead of the currently configured project. 


-f, --file <file_name>        Retrieve just a specific file or directory from the stored dataset. Note that you need to define
                              the full path of the file or directory within the stored object.

-d, --target_dir <dir_name>   If this option is defined, a new target directory is created and the data is retrieved there.

-t, --target_file <file_name> Define a file name for the object for the object to be downloaded.

-l, --original_location       Retrieve the data to the original location in the directory structure.

--asis                        Download the object without unpacking tar files and uncompressing zst compressed data.

--sk <secret key>             Secret key to open crypt4gh encryption.

--s3cmd                       Use S3 protocol and s3cmd command for data retrieval instead of Swift protocol and rclone.

Related commands: a-put, a-find, a-info, a-delete

```
