#!/bin/sh
export RESET_ENV="True"

ANS_CODE="../ansible"
source ./my_vars
source ./common_vars
ansible-playbook ${ANS_CODE}/reset_local_environment.yml --extra-vars "${EXTRA_VARS}"
