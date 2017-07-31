#!/usr/bin/env python
import argparse
import yaml

if __name__ == '__main__':

  parser = argparse.ArgumentParser()
  parser.add_argument('-f', '--file', help='YAML File to parse', required=True)
  parser.add_argument('-m', '--masters', help='return list of masters', action='store_true',required=False)
  parser.add_argument('-n', '--nodes', help='return list of nodes', action='store_true',required=False)
  parser.add_argument('-w', '--wildcard', help='returns the wildcard DNS hostname', action='store_true',required=False)
  parser.add_argument('-o', '--origin', help='returns True if deploy_origin=true', action='store_true',required=False)
  args = parser.parse_args()

  file_path = args.file

  if args.masters:
        print_full = False

  with open(file_path, 'r') as f:
    try:
      file = yaml.load(f)
      if args.masters:
        print file["hosts"]["masters"]
      elif args.nodes:
        print file["hosts"]["nodes"]
      elif args.wildcard:
        # return just the string value without '[]' (e.g master vs [master])
        print file["hosts"]["wildcard_dns_host"][-1]
      elif args.origin:
        if "deploy_origin" in file:
          print file["deploy_origin"]
      else:
        print file["hosts"]

    except yaml.YAMLError as exc:
      print (exc)
