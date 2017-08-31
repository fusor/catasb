#!/usr/bin/env python

import urllib
import sys
import re
from HTMLParser import HTMLParser

oc_clients_url = 'https://mirror.openshift.com/pub/openshift-v3/clients/'

class CientListHTMLParser(HTMLParser):
    def __init__(self, version):
        HTMLParser.__init__(self)
        self.processing_anchor = False
        self.version = version
        self.latest_version = None

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            self.processing_anchor = True

    def handle_endtag(self, tag):
        if tag == 'a':
            self.processing_anchor = False

    def handle_data(self, data):
        if self.processing_anchor:
            # We are counting on the client list to already be sorted from low to high
            if re.search('^' + self.version, data):
                self.latest_version = data

if re.match('linux', sys.platform):
    platform = 'linux'
elif re.match('darwin', sys.platform):
    platform = 'macosx'
else:
    sys.exit(1)

client_list_html = urllib.urlopen(oc_clients_url).read()

parser = CientListHTMLParser(sys.argv[1])
parser.feed(client_list_html)
if parser.latest_version is None:
    sys.exit(1)
version = parser.latest_version
sys.stdout.write(oc_clients_url + version + platform + '/oc.tar.gz')
sys.stdout.flush()
