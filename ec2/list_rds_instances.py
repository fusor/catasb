#!/usr/bin/env python

import os
import sys
from boto import rds

if os.environ.get('AWS_ACCESS_KEY_ID') is None:
    print "Missing Environment Variable:  AWS_ACCESS_KEY_ID"
    sys.exit(1)

if os.environ.get('AWS_SECRET_ACCESS_KEY') is None:
    print "Missing Environment Variable:  AWS_SECRET_ACCESS_KEY"
    sys.exit(1)

AWS_ACCESS_KEY_ID = os.environ['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = os.environ['AWS_SECRET_ACCESS_KEY']

if __name__ == "__main__":
    rds_conn = rds.RDSConnection(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    dbinstances = rds_conn.get_all_dbinstances()
    for dbi in dbinstances:
        print "%s, created %s, status %s" % (dbi.id, dbi.create_time, dbi.status)
