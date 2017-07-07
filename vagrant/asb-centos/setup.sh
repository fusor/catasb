#!/usr/bin/env bash

set -x

if [[ ! -f /vagrant/my_vars.yml ]]; then
  echo "my_vars.yml is required and must include:"
  echo "dockerhub_user_name: <dockerhub user>"
  echo "dockerhub_org_name: <dockerhub org name>"
  echo "dockerhub_user_password: <dockerhub password>"
  exit 1
fi

yum update -y
yum install epel-release -y
yum install ansible -y

ansible-playbook /ansible/setup_centos_vm.yml --extra-vars @/vagrant/vars.yml --extra-vars @/vagrant/my_vars.yml | tee /var/log/asb-setup.log
