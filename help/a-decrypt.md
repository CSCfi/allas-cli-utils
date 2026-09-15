# a-decrypt
 
```text
a-decrypt is used to decrypt SD Connect encrypted object that have already been uploaded to Allas.
The main purpose of this tool is to convert a file, uploaded to SD Connect service, into normal Allas object .

DEFAULT OPERATION: DECRYPT AN OBJECT IN ALLAS

The basic syntax of the command is:

   a-decrypt object_name

The command above copies the object to the local computer where SD Connect decryption is applied
to the data. The decrypted data is then copied back to Allas into a new object. 
By default the encrypted object is located to the same bucket as the original object. 
Suffix: .c4gh is removed from the object name.

You can user option --bucket the define that decrypted files will be stored to different location.
With option --all you can define that all the objects in a given location will be decrypted. 

Examples:

1. Make an decrypted copy of object my_data.csv.c4gh that locate in bucket project-12345-data

   a-decrypt project-12345-data/my_data.csv.c4gh

2. Make decrypted copies of all objects in bucket project-12345-sd to bucket  project-12345-data

   a-decrypt project-12345-sd --all --bucket project-12345-data


Note tha a-decrypt is not able to decrypt files that were encrypted with he old SD Connect method.



SUMMARY OF A-ENCRYPT OPTIONS

Options:

-a, --all                        Process all the objects that include the given name (e.g. bucket name) in the beginning of
                                 object name. 

-r, --replace                    Remove the original encrypted object after decryption.

-b, --bucket <bucket_name>       Save the decrypted object to the given bucket instead of the original bucket.


--s3cmd                          Use S3 protocol for data retrieval instead of Swift.




Related commands: a-encrypt, a-put, a-find, a-info, a-delete

```
