# allas-mount
 
```text
This tool mounts a bucket in Allas to be used as a read-only disk areas.
Syntax of the command is:

  allas-mount <bucket_name>

By default the bucket is mounted to a directory named after the bucket.
You can use optional mount points with option -m (--mountpoint)
   
   allas-mount <bucket_name> -m <dir_name>

To unmount a bucket use option -u or --umount:

   allas-mount -u  <dir_name>

Option -l (--list) lists the currently active rclone mount commands, launched by allas-mount.

   allas-mount -l

By default buckets are mounted as read-only directories. With option -w (--write) write permission is
added to the mounted bucket. Writing data to allas this way can cause problems in the cases where the
same object is modified by several processes at the same time.
   
   allas-mount <bucket_name> -w

```
