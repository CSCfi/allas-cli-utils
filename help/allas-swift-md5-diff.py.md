# allas-swift-md5-diff.py
 
```text
usage: allas-swift-md5-diff.py [-h] [-v {1,2}]
                               file_name bucket_name object_name

Compare checksums of a local file and an Allas object, outputs the local file
name if they differ. Requires swift connection

positional arguments:
  file_name             name of the local file
  bucket_name           name of the Allas bucket
  object_name           name of the object in the Allas bucket

options:
  -h, --help            show this help message and exit
  -v {1,2}, --verbosity {1,2}
                        increase output verbosity
```
