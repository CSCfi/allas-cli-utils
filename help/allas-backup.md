# allas-backup
 
```text

allas-backup

allas-backup tool provides easy to use command line interface to the restic back up tool.
(https://restic.readthedocs.io/). allas-backup automatically creates a project specific back up 
repository to the Allas storage service at CSC and uses that for making cumulative back ups.

In order to use this tool, you must first open connection to Allas storage service with
command:
   source /appl/opt/allas-cli-utils/allas_conf

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

  allas-backup restore <snapshot_id> Retrieves the data of the given snapshot to the local environment. By default 
                                 the stored data is restored to the local directory. Other locations can be 
                                 defined with -target option.

  allas-backup delete <snapshot_id>  Deletes a snapshot from the backup repository.


```
