#!/bin/sh
export RESET_ENV="True"

source ../../gather_config

ansible-playbook ${ANS_CODE}/reset_mac_environment.yml --extra-vars "${EXTRA_VARS}" ${extra_args} $@
