# allas-backup
 
```text

allas-backup

allas-backup tool provides easy to use command line interface to the restic back up tool.
(https://restic.readthedocs.io/). allas-backup automatically creates a project specific back up 
repository to the Allas storage service at CSC and uses that for making cumulative back ups.

In order to use this tool, you must first open connection to Allas storage service with
command:
   source /home/kkmattil/allas-cli-utils/allas_conf

The connection remains open for eight hours.


BACKUP OPERATIONS

allas-backup can be used for following five operations:

  allas-backup <file_name>  or
  allas-backup add <file_name>       Add a new backup version (snapshot) of the given file 
                                     or directory to the back up repository.

  allas-backup list                  Lists the snapshots saved to the repository. 
                                     Option: -last lists only the latest versions of different snapshots.
 
  allas-backup files <snapshot_id>   List the files that the snapshot includes.

  allas-backup find <query>          Find snapshots that contain file or directory that match the given query term.

  allas-backup restore <snapshot_id> Retrieves the data of the given snapshot to the local environment. 
                                     By default the stored data is restored to the local directory. Other locations can be 
                                     defined with -target option.
                                     Existing local files will not be overwritten. Only missing files will be retrieved.

  allas-backup restore-overwrite <snapshot_id> Retrieves the data of the given snapshot to the local environment. 
                                     By default the stored data is restored to the local directory. Other locations can be 
                                     defined with -target option.
                                     Existing local files will be overwritten.    

  allas-backup restore-newer <snapshot_id> Retrieves the data of the given snapshot to the local environment. 
                                     By default the stored data is restored to the local directory. Other locations can be 
                                     defined with -target option.
                                     Existing local files will be overwritten only if the file in the snapshot has a newer modification time.                               


  allas-backup delete <snapshot_id>  Deletes a snapshot from the backup repository.

  allas-backup dump <snapshot_id> -f <file>   Retrieve contents of a file in the snapshot.

  allas-backup unlock                Remove Restic lock files.

  Extra options:
 
  -r, -repo                          Use non-default repository. This make 
                                     Allas-backup to use different repository instead of
                                     the default one. If you use this option together with
                                     -password option. You can define and use a non-default
                                     password for your repository.

  -S3, -s3                           Use S3 based backup repository

  -mode swift/S3                     Define if S3 or swift based repository is in use.

  -pre-check                         Check that you have access permissions to all the data in the
                                     directory to be backuped

  -password                          Ask for password. Use this in case of repositories for which
                                     you don't want to store the password to your home directory. 


```
