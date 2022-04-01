# allas_conf-puhti
 
```text
This script sets up the swift and/or s3cmd environment so that you can access Allas storage service. 
The name of the Allas project to be used can be defined as a command line argument.

   source allas_conf <proj_name>

If the project name is not defined, the available project names are listed and
you are asked to define the project name based on the list.

The program asks your CSC password before starting the configuration process.

By default, this tool sets up access tokens that are used by swift and rclone connections
 
Definition:

-mode s3cmd

will initiate s3cmd configuration in stead of swift configuration.

Definition:

--mode both

will initiate both swift and s3cmd configuration.

During s3cmd configuration, you will be asked to confirm several values and settings
You should accept the default values in all exept the last setep.
 WHEN THE TOOL ASKS:
     Save settings? [y/N]
YOU SHOULD ANSVER: y
 
Other options:
  --user <username>    Define usename to be used for authentication to the storage server.
                      If this option is not defined, current username will be used.

  --keeppasswd         Don't reset the OS_PASSWORD environment variable once the configuration
                      is done. This can be useful if you use this tool in scripts that need to
                      switch between projects.

  --silent             Less output
allas_conf should not be executed directly
Use sourcing in stead: 
   source allas_conf -u CSC-usrname allas_project
```
