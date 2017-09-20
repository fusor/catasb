#!/bin/sh
export RESET_ENV="True"

# [[ "${1}" == "-k" ]] ||
# [[ "${1}" == "k8s" ]] ||
# [[ "${1}" == "kubernetes" ]]
# CLUSTER=kubernetes
source ../../gather_config

ansible-playbook ${ANS_CODE}/setup_local_environment.yml --extra-vars "${EXTRA_VARS}" ${extra_args} $@
