#! /usr/bin/env python
import os
import sys
import time
import yaml


def parse(filename):
    with open(filename, 'r') as f:
        raw_data = f.read()
    return yaml.load(raw_data)


def update_identity_provider(data, auth_file):
    """
    Default oc cluster up gives us the below

      identityProviders:
      - challenge: true
        login: true
        mappingMethod: claim
        name: anypassword
        provider:
          apiVersion: v1
          kind: AllowAllPasswordIdentityProvider

    We want to change this to:
      identityProviders:
      - name: my_htpasswd_provider
        challenge: true
        login: true
        mappingMethod: claim
        provider:
          apiVersion: v1
          kind: HTPasswdPasswordIdentityProvider
          file: /path/to/users.htpasswd
    """
    current_provider = data["oauthConfig"]["identityProviders"][0]
    current_provider["name"] = "catasb_htpasswd"
    current_provider["provider"]["kind"] = "HTPasswdPasswordIdentityProvider"
    current_provider["provider"]["file"] = auth_file
    return data


if __name__ == "__main__":
    input_file = sys.argv[1]
    auth_file = sys.argv[2]
    data = parse(input_file)
    update_identity_provider(data, auth_file)
    pretty_format_data = yaml.dump(data, default_flow_style=False)
    os.rename(input_file, "%s.%s" % (input_file, time.time()))

    with open(input_file, "w") as f:
        f.write(pretty_format_data)
