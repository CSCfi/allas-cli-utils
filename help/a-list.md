# a-list
 
```text
This tool is used to list buckets and objects in Allas or Lumi-o. If bucket name is not defined, all buckets are listed. 
If bucket name is defined, then objects inside the bucket are listed.



   a-list <bucket_name>


Options:

-d  --dir               List content so that  / -characters on object names are used to define a directory structure.

-l, --lh <project_ID>   Print out detailed listing of the buckets or objects in a bucket.

-p, --prefix            List only objects starting with the given prefix.


Working with shared buckets:

                        When you list a contents of a bucket with a-list, the command checks if the bucket used 
                        belongs to the current project. If it does not belong to the project, the name of the shared 
                        bucket is stored to Allas or Lumi-o ( into object project-number-a-tools/buckets_shared_to).
                        When you check the available buckets with command a-list, the command shows also the names of
                        the shared buckets stored to Allas or Lumi-o. NOTE that this option shows information about only about 
                        shared buckets that have previously been used by a-list. Thus you can't use a-list check if some
                        new buckets has been shared to you.


                    

Related commands: a-put, a-get, a-delete, a-find

```
