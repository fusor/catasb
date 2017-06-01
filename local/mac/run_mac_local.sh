#!/bin/sh

ANS_CODE="../../ansible"
source ./common_vars
ansible-playbook ${ANS_CODE}/setup_mac_environment.yml --extra-vars "${EXTRA_VARS}"
