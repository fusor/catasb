#!/bin/sh

time (./run_create_infrastructure.sh && ./run_openshift_ansible.sh && ./run_post_aos_install.sh && ./display_information.sh)
