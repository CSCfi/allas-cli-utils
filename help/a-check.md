# a-check
 
```text



This tool is used to check if Allas already includes objects that would matching objects
that a-put would create. This command can be use check the success of a data upload process
done with a-put. Alternatively, the results can be used to list objects that need to be removed
or renamed, before uploading a new version of a dataset to Allas
For example, if you have uploaded a directory to Allas using command:
   a-put datadir/*
You can use command:
   a-check datadir/*
To check if all the directories and files have corresponding objects in Allas.
If you have defined a bucket with option -b, you must include this option
in the a-check command too:
  a-put -b 123_bucket datadir/*
Checking:
  a-check -b 123_bucket datadir/*

Note that the checking is done only based on the names of files, directories and objects.
The contents of the files and objects are not checked!
a-check command line options:

-b, --bucket <bucket_name>  Define a name of the bucket into
                            which the data is uploaded.

-p, --project <project_ID>  Upload data into buckets of the defined
                            project instead of the currently
                            configured project.

-o, --object <object_name>  Define a name for the new object to be
                            created.

-S, --s3cmd                 Use S3 protocol instead of swift protocol
                            for upload.

-n, --nc                    Do not compress the data that will be uploaded.
                            (This is now the default mode thus this option is
                            no longer needed).

-c, --compress              The data is compressed using zstdmt command before
                            upload.

-h, --help                  Print this help.

-t, --tmpdir                Define a directory that will be used to store
                            temporary files of the upload process.

-s, --silent                Less output

-u, --user                  Define username liked to the data to be uploaded
                            (default: current username)

--skip-filelist             Do not collect information about the files that
                            the object contains to the metadata file.
                            Using this option speeds up the upload process
                            significantly if the directory to be uploaded
                            contains large amount of files. However, a-find
                            can't be used to locate objects uploaded this way.

--no-ameta                  Don't create metadata objects ( _ameta ) for the
                            stored data objects.

-m, --message "your notes"  Add a one line text note to the metadata object.

--override                  Allow overwriting existing objects.

--input-list <list_file>    Give a file that lists the files or directories 
                            to be uploaded to Allas.
                            Each item will be stored as one object.

-a, --asis                  Copy the given file or content of a directory to Allas
                            without compression and packing so that each file in the
                            directory will be copied to Allas as an individual object.
                            The object name contains the relative path of the file to
                            be copied.

--follow-links              When uploading a directory, include linked files as real files
                            instead of links.

-e, --encrypt <method>     Options: gpg and c4gh. Encrypt data with gpg or crypt4gh.

--pk, --public-key          Public key used for crypt4gh encryption.

--sdx                       Upload data to Allas in format format that is compatible with
                            the CSC Sensitive data services: The files are encrypted with
                            crypt4gh using CSC public key after which the files are imported
                            to Allas as individual objects as in --asis format.
                            With --public-key you can do the encryption with both
                            CSC and your own public key. By default data is stored to bucket with name:
                            your-project-number_SD-CONNECT,


Related commands: a-find, a-get, a-delete, a-info
```
