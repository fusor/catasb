#!/bin/sh

ANS_CODE="../../ansible"
source ./common_vars
ansible-playbook ${ANS_CODE}/setup_local_environment.yml --ask-become-pass --extra-vars "${EXTRA_VARS}"
