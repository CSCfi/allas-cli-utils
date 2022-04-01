# a-delete
 
```text
This tool is used to remove data that has been uploaded to Allas service using the a-put command.
The basic syntax of the comand is:

   a-delete object_name


Options:

-p, --project <project_ID>   Delete objects form the buckets of the defined project in stead of the currently configured project. 

-b --bucket                  Object name includes bucket name and the command does not try to use the default bucket names.

-u, --user <username>        Option allows you to assign a user account that is used to confoirm the object ownership.

-f, --force                  Don't ask confirmation when deleting a file
 
--rmb                        Remove empty bucket. 

-F, --FORCE                  In conjunction with --rmb, this option removes a non-empty bucket.


Related commands: a-put, a-get, a-find, a-info
```
