# lo-find
 
```text
This tool is used to find:
 1. Objects, whose name matches to the query
 2. a-put generated objects that contain matching file names.

The basic syntax of the command is:

   a-find query_term


The query term is compared to the object names as well as the names and original paths of the files that
have been uploaded to LUMI-O with a-put. The matching objects are reported (but not downloaded).

The query term is processed as a regular expression where some characters, for example dot (.), have a special meaning.
The same regular expression syntax is used with e.g. grep, awk and sed commands.
The most commonly occurring special characters are listed below:

    the dot (.) is used to define any single character.
    ^ means the beginning of a line
    $ means the end of a line
    [ ] matches any of the characters inside the brackets. For example [abc] would match a,b or c.
    [^ ] matches any character, except the characters inside the brackets.
    For example [^abc] would select all rows that contain also other characters
    than just a,b and c.
    * matches zero or more of the preceding character or expression
    \{n,m\} matches n to m occurrences of the preceding character or expression

Options:

-f, --files                  Lists the names of the matching files inside the objects in addition to the object name.

-p, --project <project_ID>   Search matches form the buckets of the defined project instead of the currently configured project.

-b, --bucket <bucket_name>   By default all the standard buckets, used by a-put, are searched. Option --bucket allows you to specify a
                        single bucket that will be used for the search.

-a, --all                    By default all the standard buckets, used by a-put, are searched. Option --all defines
                             that all the buckets of the project will be included in the search.

-s, --silent                 Output just the object names and number of hits. If -file option is included,
                             print object name and matching file name on one row.


Related commands: a-put, a-get, a-delete, a-info
```
