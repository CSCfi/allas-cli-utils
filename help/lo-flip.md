# lo-flip
 
```text
lo-flip is a tool to make individual files temporary available in the internet.

lo-flip copies a file to LUMI-O into a bucket that can be publicly accessed. Thus, anyone with the address (URL) of the
uploaded data object can read and download the data with a web browser or tools like *wget* and *curl*.
lo-flip works mostly like lo-publish but there are some differences:
1) only the pre-defined bucket name ( _username-projectNumber_-flip ) can be used
2) When the command is executed it automatically deletes objects that are older than two days

The basic syntax of the command is:

  lo-flip file_name

The file is uploaded to a bucket _username-projectNumber_-flip. You can define other bucket names can't be used.
The URL to the uploaded object is:

https://a3s.fi/username-projectNumber-flip/object_name

After uploading the file to the public flip bucket, it checks up the content of the bucket and
removes object that were uploaded more than two days ago.

```
