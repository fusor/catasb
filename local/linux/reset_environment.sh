#!/bin/sh

source ../../gather_config

ansible-playbook ${ANS_CODE}/setup_local_environment.yml --extra-vars "${EXTRA_VARS}" ${extra_args} $@
