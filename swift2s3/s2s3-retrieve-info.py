#!/usr/bin/env python3

# This is called from allas-swift2s3
# Retrieves information abut objects in a bucket
# Writes the information about non-segmented files to one file and about segmented to another file

import os, sys, json
import boto3
import re
from urllib.parse import unquote

# Temporary fix for Puhti's biopythontools module: ignore warnings when importing requests
import warnings
warnings.simplefilter("ignore")
import requests
warnings.simplefilter("default")

if len(sys.argv) < 3:
    print('usage: ' + sys.argv[0] + ' bucket-name output-prefix [aws-auth-profile-name]', file=sys.stderr)
    sys.exit(1)

bucket = sys.argv[1]
output_prefix = sys.argv[2]

profile = 'default'
if len(sys.argv) == 4:
    profile = sys.argv[3]

swift_token = os.getenv('OS_AUTH_TOKEN')
storage_url = os.getenv('OS_STORAGE_URL')

if (storage_url == None) or (swift_token == None):
    print("Missing swift OS_AUTH_TOKEN or OS_STORAGE_URL", file=sys.stderr)
    sys.exit(1)

# Create both output files

try:
    file_normal = open(output_prefix + bucket, mode="w")
except Exception as err:
    print("error: file: " + output_prefix + bucket + " " + repr(err))
    sys.exit(1)

try:
    file_segmented = open(output_prefix + bucket + "_segmented", mode="w")
except Exception as err:
    print("error: file: " + output_prefix + bucket + "_segmented " + repr(err))
    sys.exit(1)

# S3 connections

s3session = boto3.session.Session(profile_name=profile)
s3 = s3session.client("s3", endpoint_url='https://a3s.fi')

s3segments_session = boto3.session.Session(profile_name=profile)
s3segments = s3segments_session.client("s3", endpoint_url='https://a3s.fi')

re_tail_pattern=re.compile(r"/\d+$")
re_path_pattern=re.compile(r"^[A-Za-z0-9_\-\.]*/")
re_bucket_pattern=re.compile(r"/.*")

def static_segment_path(segment_bucket, short_prefix):
    # Returns the full prefix part of the segment object name

    _response = s3segments.list_objects(Bucket=segment_bucket, Marker=marker, Prefix=short_prefix)

    for _one in _response ['Contents']:
       _segments_path = re_tail_pattern.sub("/", _one["Key"])
       return (_segments_path)

    return("")

# Info retrieval loop

marker = ''
while True:
    response = s3.list_objects(Bucket=bucket, Marker=marker)

    for one in response ['Contents']:
        segmented_object = False
        segment_manifest = ""
        segment_bucket = ""
        segment_path = ""

        object_headers = requests.head(storage_url + "/" + bucket + "/" + one [u'Key'], headers = {"X-Auth-Token": swift_token})

        # SLO
        if (('X-Static-Large-Object' in object_headers.headers) and (object_headers.headers [u'X-Static-Large-Object'] == 'True')) or (('X-Object-Meta-Static-Large-Object' in object_headers.headers) and (object_headers.headers [u'X-Object-Meta-Static-Large-Object'] == 'True')):
            segmented_object = True
            # Allas does not currently return manifest with multipart-manifest=get, so assume "_segments"
            segment_bucket = bucket + "_segments"
            segment_path = static_segment_path(segment_bucket, one["Key"] + "/")

        # DLO
        if ('X-Object-Manifest' in object_headers.headers):
            segmented_object = True
            segment_manifest = object_headers.headers [u'X-Object-Manifest']
            segment_bucket = re_bucket_pattern.sub("", segment_manifest)
            segment_path = re_path_pattern.sub("", segment_manifest)

        if (segmented_object == True):
            print(one["Key"] + "\t" + segment_bucket + "\t" + unquote(segment_path), file=file_segmented)
        else:
            print(one["Key"], file=file_normal)

    if response ['IsTruncated']:
        marker = response ['NextMarker']
        file_normal.flush()
        file_segmented.flush()
    else:
        break

s3segments.close()
s3.close()

file_segmented.close()
file_normal.close()

