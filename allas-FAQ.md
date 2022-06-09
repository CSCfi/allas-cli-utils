# Frequently asked questions about using Allas and A-tools

**Q: Data transfer seems to continue forerver
and the output shows that well over 100% of the data has been transported. Is this normal?**

**A:** This is not normal. This kind of error has accurred several times, but sofar we don't know what is causing this
Please kill your data transfer process (Ctrl-c) and try running the same command again.


**Q: How I can download the data with a-get without having to download each individual object using a separate a-get command?**

**A:** I am afraid that you have to run a-get commands one by one.

What you can do is first create a list of objects
to be downloaded:
```text
a-list your-bucket | grep "some-regexp" > object_list
```
And then use the list in a for loop
```text
for ob in $(cat object_list)
do
 a-get $ob
done
```
