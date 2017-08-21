#!/usr/bin/env python

import urllib
import sys
import re
from HTMLParser import HTMLParser


class CientListHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.processing_anchor = False
        self.latest_version = None

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            self.processing_anchor = True

    def handle_endtag(self, tag):
        if tag == 'a':
            self.processing_anchor = False

    def handle_data(self, data):
        if self.processing_anchor:
            match = re.search('(\d+)\.(\d+)\.(\d+)\.(\d+)\.(\d+)', data) or re.search('(\d+)\.(\d+)\.(\d+)\.(\d+)', data) or re.search('(\d+)\.(\d+)\.(\d+)[^\-]', data)
            if match:
                if self.latest_version is None:
                    self.latest_version = match.groups()
                else:
                    for idx, version_str in enumerate(match.groups()):
                        if idx >= len(self.latest_version):
                            self.latest_version = match.groups()
                            break
                        latest = int(self.latest_version[idx])
                        current = int(version_str)
                        if current > latest:
                            self.latest_version = match.groups()
                            break
                        if version_str < self.latest_version[idx]:
                            break

if re.match('linux', sys.platform):
    platform = 'linux'
elif re.match('darwin', sys.platform):
    platform = 'macosx'
else:
    sys.exit(1)

client_list_html = urllib.urlopen('https://mirror.openshift.com/pub/openshift-v3/clients/').read()

parser = CientListHTMLParser()
parser.feed(client_list_html)
if parser.latest_version is None:
    sys.exit(1)
version = '.'.join(parser.latest_version)
sys.stdout.write('https://mirror.openshift.com/pub/openshift-v3/clients/' + version + '/' + platform + '/oc.tar.gz')
sys.stdout.flush()
