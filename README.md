# CATalogASB

catasb is a collection of playbooks to create an OpenShift environment with a [Service Catalog](https://github.com/kubernetes-incubator/service-catalog) & [Ansible Service Broker](https://github.com/openshift/ansible-service-broker) in a local or EC-2 environment.


For an overview of Ansible Service Broker and Ansible Playbook Bundles click [here](https://github.com/openshift/ansible-service-broker/blob/master/docs/introduction.md)

### Overview
These playbooks will:
  * Setup an OpenShift or Kubernete cluster
  * Install [Service Catalog](https://github.com/kubernetes-incubator/service-catalog) on Origin
  * Install [Ansible Service Broker](https://github.com/openshift/ansible-service-broker) on Origin


### OpenShift or Kubernetes
Kubernetes
  * Run local scripts with -k or k8s or kubernetes
  * Set the ansible variable 'cluster' to 'kubernetes'

OpenShift
  * OpenShift doesn't require any flags to run


### Local and EC-2 deployment options
  * To view individual Readme documents for these options click below
  * [Kubernetes setup](kubernetes/README.md)
  * [Local Linux deployment](local/linux/README.md)
  * [Local macOS deployment](local/mac/README.md)
  * [EC-2 deployment](ec2/README.md)


### Summit 2017 demo
  * To recreate the demonstration from Red Hat Summit 2017 (shown [here](https://github.com/fusor/catasb/pull/87) on YouTube), checkout the branch [summit2017](https://github.com/fusor/catasb/tree/summit2017).
  ```bash
  git checkout summit2017
  ```
