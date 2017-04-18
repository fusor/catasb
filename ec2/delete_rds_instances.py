#!/usr/bin/env python

import os
import sys
import datetime
import dateutil.parser
from dateutil.tz import tzutc

from pprint import pprint
from boto import rds

SAVED_INSTANCES=["ansibleapp-postgres-1491932146"]
NUM_HOURS=6

if os.environ.get('AWS_ACCESS_KEY_ID') is None:
    print "Missing Environment Variable:  AWS_ACCESS_KEY_ID"
    sys.exit(1)

if os.environ.get('AWS_SECRET_ACCESS_KEY') is None:
    print "Missing Environment Variable:  AWS_SECRET_ACCESS_KEY"
    sys.exit(1)

AWS_ACCESS_KEY_ID = os.environ['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = os.environ['AWS_SECRET_ACCESS_KEY']

def ignore_saved_instances(instances, saved):
    return filter(lambda x: x.id not in saved and x.status == "available", instances)

def restrict_to_older(instances, num_hours):
    now = datetime.datetime.now(tzutc())
    cut_off_time = now - datetime.timedelta(hours=num_hours)
    return filter(lambda x: dateutil.parser.parse(x.create_time) < cut_off_time, instances)

def delete_instances(conn, instances):
    print "%s instances found to delete" % (len(instances))
    for dbi in instances:
        if dbi.status == "available":
            print "Will delete instance: %s, created %s, status %s" % (dbi.id, dbi.create_time, dbi.status)
            conn.delete_dbinstance(dbi.id, skip_final_snapshot=True)
        else:
            print "Skipping instance: %s, created %s, status %s" % (dbi.id, dbi.create_time, dbi.status)

if __name__ == "__main__":
    rds_conn = rds.RDSConnection(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    dbinstances = rds_conn.get_all_dbinstances()
    possible_instances = ignore_saved_instances(dbinstances, SAVED_INSTANCES)
    older_instances = restrict_to_older(possible_instances, NUM_HOURS)
    delete_instances(rds_conn, older_instances)
