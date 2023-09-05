#!/usr/bin/env python3

# This is called from allas-swift2s3
# Compares file/object segment checksums
# Gets Allas checksums json from stdin

import sys
import os
import json
import hashlib

if (len(sys.argv) != 2):
    print("usage: " + sys.argv[0] + " filename", file=sys.stderr)
    print("       also the json is expected to come from stdin", file=sys.stderr)
    sys.exit(1)

filename = sys.argv[1]
segment_size = 0
checksums_json = ""
checksums_file = ""

# process the json from stdin

try:
    all_objects = json.load(sys.stdin)
except json.decoder.JSONDecodeError as err:
    print("error: invalid json from stdin for file: " + filename, file=sys.stderr)
    sys.exit(1)

if len(all_objects) == 0:
    print("error: empty json from stdin for file: " + filename, file=sys.stderr)
    sys.exit(1)
else:
    try:
        # figure out segment size and the checksums
        segment_size = all_objects['Contents'][0]['Size']
        if not type(segment_size) == int:
            print("error: invalid segment size for file: " + filename, file=sys.stderr)
            sys.exit(1)

        for one_object in all_objects['Contents']:
            checksum = one_object['ETag'].replace('"', "")
            checksums_json = checksums_json + " " + checksum

    except Exception as err:
        print("error: json for file: " + filename + " " + repr(err), file=sys.stderr)
        sys.exit(1)

if segment_size == 0:
    print("error: segment size not available for file: " + filename, file=sys.stderr)
    sys.exit(1)

# for md5 sums figure out buffer size for reading the file

max_chunk = 0
buf_sizes=(4000, 4096, 1000, 1024)
try:
    for buffer_size in buf_sizes:
        if (segment_size % buffer_size) == 0:
            max_chunk = (segment_size // buffer_size)
            break
except TypeError as err:
    print("warning: skip checksum check, unexpected segment size: \"" + str(segment_size) + "\" for file: " + filename, file=sys.stderr)
    sys.exit(1)

if max_chunk == 0:
    print("warning: skip checksum check, unexpected segment size: \"" + str(segment_size) + "\" for file: " + filename, file=sys.stderr)
    sys.exit(1)

# calculate md5 sums

md5_hash = hashlib.md5()
count = 1
try:
    # figure out local file segment checksums
    with open(filename,"rb") as f:
        for byte_block in iter(lambda: f.read(buffer_size),b""):
            md5_hash.update(byte_block)
            if (count == max_chunk):
                checksums_file = checksums_file + " " + md5_hash.hexdigest()
                md5_hash = hashlib.md5()
                count = 0
            count = count + 1
        checksums_file = checksums_file + " " + md5_hash.hexdigest()
except FileNotFoundError as err:
    print("error: file not found: " + filename, file=sys.stderr)
    sys.exit(1)
except Exception as err:
    print(repr(err), file=sys.stderr)
    sys.exit(1)

# compare Allas and local checksum strings, report only if they differ

if checksums_json != checksums_file:
    print("error: json and file segment checksums differ for file " + filename, file=sys.stderr)
    print("       json:" + checksums_json, file=sys.stderr)
    print("       file:" + checksums_file, file=sys.stderr)
    sys.exit(1)

