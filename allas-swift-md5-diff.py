#!/usr/bin/env python3

# This compares md5 checksum(s) of a local file and a swift uploaded Allas object
# If the checksum(s) differ, the local file name is printed to stdout
# Segmented objects have content checksums for segments only and getting that info is a bit difficult in Allas, but this program does it's best to figure out where the segments are...
# -v1 and -v2 verbose options print progress etc info to stderr, to keep clean the differing file name output

DESCRIPTION='Compare checksums of a local file and an Allas object, outputs the local file name if they differ. Requires swift connection'

import os, sys, json
import re
import hashlib
import argparse
import requests

parser = argparse.ArgumentParser(description=DESCRIPTION)
parser.add_argument("file_name", help="name of the local file")
parser.add_argument("bucket_name", help="name of the Allas bucket")
parser.add_argument("object_name", help="name of the object in the Allas bucket")
parser.add_argument("-v", "--verbosity", type=int, choices=[1, 2], help="increase output verbosity")
args = parser.parse_args()

filename = args.file_name
bucket = args.bucket_name
object = args.object_name
verbosity=args.verbosity

swift_token = os.getenv('OS_AUTH_TOKEN')
storage_url = os.getenv('OS_STORAGE_URL')

if (storage_url == None) or (swift_token == None):
    print("error: missing swift OS_AUTH_TOKEN or OS_STORAGE_URL", file=sys.stderr)
    sys.exit(1)

re_tail_pattern=re.compile(r"/\d+$")
re_path_pattern=re.compile(r"^[A-Za-z0-9_\-\.]*/")
re_bucket_pattern=re.compile(r"/.*")

def static_segment_path(segment_bucket, short_prefix):
    # Returns the full prefix part of the segment object name

    _seg_objects = requests.get(storage_url + "/" + segment_bucket, headers = {"X-Auth-Token": swift_token, "prefix": short_prefix})
    if _seg_objects.status_code != 200:
        print("error: http: " + str(_seg_objects.status_code) + " object: " + segment_bucket + "/" + short_prefix, file=sys.stderr)
        sys.exit(1)

    _one = _seg_objects.text.partition('\n')[0]
    _segments_path = re_tail_pattern.sub("/", _one)
    return(_segments_path)

if verbosity == 1 or verbosity == 2:
    print("info: " + filename, file=sys.stderr)

checksums_object = ""
checksums_file = ""
segment_size = 0

segmented_object = False
segment_manifest = ""
segment_bucket = ""
segment_path = ""

# find out if the object is segmented

object_headers = requests.head(storage_url + "/" + bucket + "/" + object, headers = {"X-Auth-Token": swift_token})
if object_headers.status_code != 200:
    if object_headers.status_code == 404:
        # no such object
        if verbosity == 1 or verbosity == 2:
            print("info: no such object, file: " + filename, file=sys.stderr)
        print(filename)
        sys.exit(0)
    else:
        print("error: http: " + str(object_headers.status_code) + " object: " + object, file=sys.stderr)
        sys.exit(1)

if (('X-Static-Large-Object' in object_headers.headers) and (object_headers.headers [u'X-Static-Large-Object'] == 'True')) or (('X-Object-Meta-Static-Large-Object' in object_headers.headers) and (object_headers.headers [u'X-Object-Meta-Static-Large-Object'] == 'True')):
    segmented_object = True
    segment_bucket = bucket + "_segments"
    segment_path = static_segment_path(segment_bucket, object + "/")

if ('X-Object-Manifest' in object_headers.headers):
    segmented_object = True
    segment_manifest = object_headers.headers [u'X-Object-Manifest']
    segment_bucket = re_bucket_pattern.sub("", segment_manifest)
    segment_path = re_path_pattern.sub("", segment_manifest)
    if not segment_path.endswith('/'):
        segment_path += '/'

# find out checksum(s)

if segmented_object == False:
    if 'ETag' in object_headers.headers:
        checksums_object = object_headers.headers [u'ETag']

        try:
            with open(filename, "rb") as file:
                file_hash = hashlib.md5()
                chunk = file.read(8192)
                while chunk:
                    file_hash.update(chunk)
                    chunk = file.read(8192)

            checksums_file = file_hash.hexdigest()
        except FileNotFoundError as err:
            print("error: file not found: " + filename, file=sys.stderr)
            sys.exit(1)
        except Exception as err:
            print(repr(err), file=sys.stderr)
            sys.exit(1)
    else:
        print("error: no checksum (ETag) in metadata, object: " + object, file=sys.stderr)
        sys.exit(1)
else:
    # segmented object

    seg_json = requests.get(storage_url + "/" + segment_bucket + "/?prefix=" + segment_path, headers = {"X-Auth-Token": swift_token, 'Accept': 'application/json', "format": "json"})
    all_objects = seg_json.json()
    try:
        segment_size = all_objects[0]['bytes']
        if not type(segment_size) == int:
            print("error: invalid segment size for object: " + segment_path, file=sys.stderr)
            sys.exit(1)

        for one_object in all_objects:
            checksum = one_object['hash'].replace('"', "")
            checksums_object = checksums_object + " " + checksum

    except Exception as err:
        print("error: json for object: " + segment_path + " " + repr(err), file=sys.stderr)
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
        print("error: skip checksum check, unexpected segment size: \"" + str(segment_size) + "\" for file: " + filename, file=sys.stderr)
        sys.exit(1)

    if max_chunk == 0:
        print("error: skip checksum check, unexpected segment size: \"" + str(segment_size) + "\" for file: " + filename, file=sys.stderr)
        sys.exit(1)

    # calculate file md5 checksums

    md5_hash = hashlib.md5()
    count = 1
    try:
        with open(filename,"rb") as file:
            for byte_block in iter(lambda: file.read(buffer_size),b""):
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

checksums_object = checksums_object.lstrip(' ')
checksums_file = checksums_file.lstrip(' ')

if verbosity == 2:
    print("info:   object cheksum(s): " + checksums_object, file=sys.stderr)
    print("info:   file cheksum(s)  : " + checksums_file, file=sys.stderr)

# compare Allas and local checksum strings

if checksums_object != checksums_file:
    print(filename)

