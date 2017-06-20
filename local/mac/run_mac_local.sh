#!/bin/sh
export RESET_ENV="True"

extra_args=''
ANS_CODE="../../ansible"
source ./env_vars
[[ ! -e my_vars.yml ]] || extra_args='-e @my_vars.yml'
ansible-playbook ${ANS_CODE}/setup_local_environment.yml \
  --extra-vars=@../config/local_vars.yml \
  --extra-vars=@../config/mac_vars.yml \
  --extra-vars "${EXTRA_VARS}" \
  $extra_args $@
