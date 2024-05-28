# a-get
 
```text
This tool is used to download data that has been uploaded to Allas service using the a-put command.
The basic syntax of the command is:

   a-get object_name

By default the object is retrieved and decompressed 

Options:

-p, --project <project_ID>    Search matches form the buckets of the defined project instead of the currently configured project. 


-f, --file <file_name>        Retrieve just a specific file or directory from the stored dataset. Note that you need to define
                              the full path of the file or directory within the stored object.

-d, --target_dir <dir_name>   If this option is defined, a new target directory is created and the data is retrieved there.

-t, --target_file <file_name> Define a file name for the object for the object to be downloaded.

-l, --original_location       Retrieve the data to the original location in the directory structure.

--asis                        Download the object without unpacking tar files and decompressing zst compressed data.

--sk <secret key>             Secret key to open crypt4gh encryption.

-T, --tmpdir                  Define a directory that will be used to store 
                              temporary files of the download process.


--allas                       Get data from Allas with swift protocol in stead of currently set storage server. 
                              Normally this (Allas with swft) is the default and this option is not needed,
                              but if you have set e.g. Lumi-O as the default storage server, this option can be
                              used to get data from Allas without changing the default storage server.
                              
--s3cmd                       Use Allas with S3 protocol.

--lumi                        Get data from Lumi-O with S3 protocol in stead of the default storage server. 
                              If Lumi-O is defined to be the default storage server and this option is not needed.
                           

Related commands: a-put, a-find, a-info, a-delete

```
