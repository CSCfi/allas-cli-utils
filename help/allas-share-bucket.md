# allas-share-bucket
 
```text

By default, only project members can read and write the data in a bucket.
Members of the project can grant read and write access to the bucket and 
the objects it contains, for other Allas projects or make the bucket publicly
accessible to the internet.

allas-share-bucket tool gives the sepcified read and write permissions to
the bucket defined for both SWIFT and S3 protocols. 

Before running this command you need to setup the allas connenction 
with commands:

   module load allas
   allas-conf --mode both -k 
 

allas-share-bucket command needs three mandatory arguments:

 -b, --bucket           The buckey to be shared

 -p, --project          Name of the project for wich 
                        the access will be garnted

 -i, --id               ID of the project for wich
                        the access will be garnted

Note, that you need to define both the ID and the name of the target project.

For example, to allow members of project: project_2001234 
(id; 3dsd9wdjjd93kdkd9d4r ) to have read-only access to
bucket: my_data_bucket you can use command:

  a-access -p project_2001234 -i 3dsd9wdjjd93kdkd9d4r -b my_data_bucket

The access permissions are set similarly to the corresponding _segments 
bucket too.

Note, that bucket listing tools don't show the bucket names of other projects,
not even in cases were the project has read and/or write permissions to the bucket.

For example in this case a user, belonging to project project_2001234, 
don't see the my_data_bucket in the bucket list produced by command:
  
  a-list

but the user can still list the contents of this bucket with command: 

  a-list my_data_bucket


```
