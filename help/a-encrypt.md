# a-encrypt
 
```text
a-encrypt is used to apply SD Connect encryption to objects, that have already been uploaded to Allas.
The main purpose of this tool is to make a file, uploaded to the Allas service, compatible with the
SD Connect and SD Desktop services of CSC. Note that you must have SD Connect connection defined in 
order to use this command.

DEFAULT OPERATION: ENCRYPT AN OBJECT IN ALLAS

The basic syntax of the command is:

   a-encrypt object_name

The command above copies the object to the local computer where SD Connect encryption is applied
to the data. The encrypted data is then copied back to Allas into a new object. 
By default the encrypted object is located to the same bucket as the original object. 
Suffix: .c4gh is added to the object name.

You can user option --bucket the define that encrypted files will be stored to different location.
With option --all you can define that all the objects in a given location will be encrypted. 

Examples:

1. Make an encrypted copy of object my_data.csv that locate in bucket project-12345-data

   a-encrypt project-12345-data/my_data.csv

2. Make encrypted copies of all objects in bucket  project-12345-data to bucket  project-12345-sd

   a-encrypt project-12345-data --all --bucket project-12345-sd


CONVERTING OLD SD CONNECT FORMATTED OBJECTS INTO CURRENT SD CONNECT FORMAT

a-encrypt can be used to convert objects that have been encrypted with the old SD Connect format 
or with crypt4gh program into the current SD Connect format. In order to do this you must have
the corresponding crypt4gh secret key in the machine where where you execute this command. 
Note that during the conversion the data will be temporary store in a readable format in the machine
where the command is executed

The conversion process is enabled and the key file defined with option "--sdx-to-sdc your-secret-key"

For example:

    a-encrypt --sdx-to-sdc project_key.sec  project_12345_old_data/file_123.txt.c4gh

The command above will ask for the password of the defined secret key (project_key.sec) after which it will
convert object object onto current SD Connect format. As the object name file_123.txt.c4gh is already in user
prefix sdc_v2_ will be adder to the project name.

Alternatively you can define that the re-encrypted data will be stored to another folder. 
For example command:

  a-encrypt --sdx-to-sdc project_key.sec  --all project_12345_old_data  --bucket project_12345_converted_data

Would store all the objects in bucket project_12345_old_data in SD Connect encrypted format into
bucket project_12345_converted_data.

Note tha a-encrypt is not able to resolve what encryption method have been used to an encrypted file.
This means that the user must know, which files are encrypted with he old SD Connect methods and can thus be
converted into new SD Connect format.



SUMMARY OF A-ENCRYPT OPTIONS

Options:

-a, --all                        Process all the objects that include the given name (e.g. bucket name) in the beginning of
                                 object name. 

-r, --replace                    Remove the original un-encrypted object after encryption.

-b, --bucket <bucket_name>       Save the encrypted object to the given bucket instead of the original bucket.

--sdx                            Use old SD Connect encryption

--sdx-to-sdc  <secret-key>       Convert data that has been encrypted with SD Connect v1 to SD Connect v2 format
                                 The argument of this option defines the secret key that will be used to decrypt 
                                 SD Connect v1 data in the conversion process.

-p, --public_key <public key>    Use users own Public key for crypt4gh encryption. In this case data is not 
                                 compatible with SD Connect.

--s3cmd                          Use S3 protocol and s3cmd command for data retrieval instead of
                                 Swift protocol and rclone.

-s, --suffix <suffix>            Define your own suffix instead of the default suffix (.c4gh)



Related commands: a-put, a-find, a-info, a-delete

```
