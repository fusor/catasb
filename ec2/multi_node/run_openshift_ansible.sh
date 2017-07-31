#!/bin/sh
[ -z "$AWS_ACCESS_KEY_ID" ] && echo "Missing environment variable:  AWS_ACCESS_KEY_ID" && exit 1;
[ -z "$AWS_SECRET_ACCESS_KEY" ] && echo "Missing environment variable:  AWS_SECERT_ACCESS_KEY" && exit 1;
[ -z "$AWS_SSH_PRIV_KEY_PATH" ] && echo "Missing environment variable:  AWS_SSH_PRIV_KEY_PATH\nPlease set this to the path for your SSH private key\n" && exit 1;
[ ! -r "$AWS_SSH_PRIV_KEY_PATH" ] && echo -e "Unable to read file pointed to by, AWS_SSH_PRIV_KEY_PATH, $AWS_SSH_PRIV_KEY_PATH" && exit 1;

source ./export_ec2_hosts

source ../../gather_config

source ./get_ec2_username

# preinstallation checks
ansible-playbook \
  ${ANS_CODE}/openshift_ansible_preinstall_checks.yml \
  --extra-vars "${EXTRA_VARS}" \
  ${extra_args} $@
if [ $? -eq 0 ]; then
  echo -e "Openshift Ansible preinstallation check - Success!\n\n"
else
  echo -e "ERROR: Something went wrong during preinstallation check! exiting... \n"
  exit -1
fi

#
# Get and set the INVENTORY_FILE path
#
# ${AOS_INVENTORY_PATH_FILE} contains the PATH of the inventory file
# for the 'openshift-ansible' BYO playbook
#
AOS_INVENTORY_PATH=`more ${AOS_INVENTORY_PATH_FILE}`
INVENTORY_FILE="${AOS_INVENTORY_PATH}"

# Run the Openshift Ansible BYO playbook
ANSIBLE_HOST_KEY_CHECKING=False \
ansible-playbook \
  -i ${INVENTORY_FILE} \
  ${OPENSHIFT_ANSIBLE_DIR}/playbooks/byo/config.yml
