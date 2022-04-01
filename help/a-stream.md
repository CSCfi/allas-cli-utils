# a-stream
 
```text
This tool is used to stream data, that has been uploaded to Allas service using the a-put command.
The basic syntax of the command is:

   a-stream object_name

By default the object is retrieved and uncompressed 

Options:

-p, --project <project_ID>    Search matches form the buckets of the defined project in stead of the currently configured project. 

--asis                        Download the object without unpacking tar files and uncompressing zst compressed data.

--sk <secret key>             Secret key to open crypt4gh encryption.

--s3cmd                       Use S3 protocol and s3cmd command for data retrieval in stead of Swift protocol and rclone.

Related commands: a-put, a-find, a-info, a-delete

```
