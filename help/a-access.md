# a-access
 
```text

By default, only project members can read and write the data in a bucket.
Members of the project can grant read and write access to the bucket and 
the objects it contains, for other Allas projects or make the bucket publicly
accessible to the internet.

a-access is a tool to control access permissions of a bucket in Allas.

In cases where access permissions are given or removed to a spcific project the syntax is: 

   a-access +/-type project_id bucket

In cases were a public access is given or removed, the syntax is:

   a-access +/-p bucket

a-access options:

  +r,  +read <project_id>          Grant read access to the bucket for the project.
  +w,  +write <project_id>         Grant write access to the bucket for the project.
  +rw, +read-write  <project_id>   Grant read and write access to the bucket for the project.
  -r,  -read <project_id>          Remove read access from the bucket.
  -w,  -write <project_id>         Remove write access from the bucket.
  -rw, -read-write  <project_id>   Remove read and write access from the bucket to the project.
  +p,  +public                     Give public read-only access to the bucket.
  -p,  -public                     Remove public read-only access to the bucket.


For example, to allow members of project: project_2001234 to have read-only access to bucket: my_data_bucket, you 
can use command:

  a-access +r project_2001234  my_data_bucket

The access permissions are set similarly to the corresponding _segments bucket too.

Note, that bucket listing tools don't show the bucket names of other projects,
not even in cases were the project has read and/or write permissions to the bucket.

For example in this case a user, belonging to project project_2001234, 
don't see the my_data_bucket in the bucket list produced by command:
  
  a-list

but the user can still list the contents of this bucket with command:  

  a-list my_data_bucket

a-access manages the access permissions only in the project and bucket level.
Use swift post command for more sophisticated access control.

If you run a-access command for a bucket without any options,
it will print out the current settings of the bucket.


Related commands: a-put, a-get, a-list

```
