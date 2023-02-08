# lo-encrypt
 
```text
This tool is used to encrypt objects, that have already been uploaded to Allas.
The basic syntax of the command is:

   a-encrypt object_name

a-encrypt command streams the object to the local computer where crypt4gh encryption is applied
to the data stream. The encrypted data is then streamed back to Allas into a new object.
By default the object is encrypted with CSC public key only. The encrypted object is located to the
same bucket as the original object. Suffix: .c4gh is added to the object name.

The main purpose of this tool is to make a file, uploaded to the Allas service, compatible with the
Sensitive data services of CSC.

Options:

-r, --replace                    Remove the original un-encrypted object after encryption.

-b, --bucket <bucket_name>       Save the encrypted object to the given bucket instead of the original bucket.

-p, --public_key <public key>    Additional Public key for crypt4gh encryption. By default only CSC public key is used.
                                 This option allows you to include additional public keys so that data can be used
                                 outside CSC sensitive data computing environment too.

--s3cmd                          Use S3 protocol and s3cmd command for data retrieval instead of
                                 Swift protocol and rclone.

-s, --suffix <suffix>            Define your own suffix instead of the default suffix (.c4gh)

-a, --all                        Process all the objects that include the given name in the beginning of
                                 object name.

Related commands: a-put, a-find, a-info, a-delete

Examples:

1. Make an encrypted copy of object my_data.csv that locate in bucket project_12345_data

   a-encrypt project_12345_data/my_data.csv

2. Make encrypted copies of all objects in bucket  project_12345_data to bucket  project_12345_sd

   a-encrypt project_12345_data --all --bucket project_12345_sd

```
