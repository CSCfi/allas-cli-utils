# allas-cli-utils allas-swift2s3 - copy Allas swift bucket to S3 bucket

Utility to copy all objects in an Allas swift bucket to another Allas S3 bucket.
Allas swift bucket here means a bucket where data has been uploaded using swift
protocol and big objects are split to separate segments bucket. 

## Using allas-swift2s3

Requires valid both swift and s3 authentication.

In Puhti you can authenticate and set up your session to include necessary
utilities with these commands:
```text
   module load biopythontools
   module load allas
   allas-conf --mode both
```

allas-swift2s3 arguments:
```
allas-swift2s3 [-h|-1|-2] source-bucket destination-bucket tmp-dir tmp-object-dir
```

If there are segmented objects, requires at least size of the biggest object
free space in the tmp-object-dir. In addition to free space for possible
segmented object, tmp-dir needs some space for object listings.

An example run:
```
[user@puhti-login11 project_2000136]$ allas-swift2s3 2000136-old 2000136-new /scratch/project_2000136/tmp /scratch/project_2000136/tmp2
20230904-123533 Retrieving information about source objects...
20230904-123535 Copying 8 non-segmented objects...
20230904-123535 Copying 2 segmented objects...
20230904-124303 Done
```

allas-swift2s3 has two phases, first it collects the information about what are
the objects in the source bucket and which of them are segmented. Second phase copies
the objects.

You can also run only first or second phase, options:
  -1 = Run only the info retrieving (phase 1).
       Requires valid both swift and s3 authentication.
       Saves info in to tmp-dir.
  -2 = Run only the object copying (phase 2).
       Requires valid s3 authentication.
       Also requires tmp files from phase 1 tmp-dir.

This makes it possible for instance to run the first phase in an interactive
session with fresh swift token and save the listings to scratch disk, and then
run the second phase as a bacth job and use temporary local disk for tmp-object-dir.

