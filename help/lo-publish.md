# a-publish
 
```text

a-publish copies a file to Allas into a bucket that can be publicly accessed. Thus, anyone with the address (URL) of the 
uploaded data object can read and download the data with a web browser or tools like wget and curl. 
a-publish works mostly like a-put but there are some differences: 

1) a-publish can upload only files, not directories. 
2) files are not compressed but they uploaded as they are. 
3) the access control of the target bucket is set so that it is available in read-only mode to the internet.

The basic syntax of the command is:

  a-publish file_name

By default, the file is uploaded to a bucket username-projectNumber-pub. You can define other bucket names too using option -b
but you should note that this command will make all data in the bucket publicly accessible, 
including data that has been previously uploaded to the bucket.

The public URL to a data object is:

https://a3s.fi/username-projectNumber-pub/object_name

An object uploaded with a-publish can be removed from Allas with command a-delete.

a-publish options:

 -b, --bucket       Use the defined bucket instead of the default bucket name
 -o, --os_file      Define alternative name for the object that will be created  
 -i, --index        (static/dynamic).  By default a-publish creates a static index 
                    file that includes the objects that are in the target bucket when 
                    the command is executed.
                    With setting --index dynamic the command adds a JavaScript based 
                    index file to the bucket. With this option the index.html page 
                    lists the objects that are available in the bucket in the time when 
                    this page is accessed. This dynamic indexing tool can list
                    only up to 1000 files.
 --input-list       List of files to be uploaded.    
 

```
