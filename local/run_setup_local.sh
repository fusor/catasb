#!/bin/sh
export RESET_ENV="False"

ANS_CODE="../ansible"
source ./my_vars
source ./common_vars
ansible-playbook ${ANS_CODE}/setup_local_environment.yml --extra-vars "${EXTRA_VARS}"
