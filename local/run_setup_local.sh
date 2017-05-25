#!/bin/sh
export RESET_ENV="False"

extra_args=''
ANS_CODE="../ansible"
source ./common_vars
[[ ! -e my_vars.yml ]] || extra_args='-e @my_vars.yml'
ansible-playbook $ANS_CODE/setup_local_environment.yml --extra-vars "$EXTRA_VARS" $extra_args  $@
