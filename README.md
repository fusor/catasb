# CATalogASB

catasb is a collection of playbooks to create an OpenShift environment with a [Service Catalog](https://github.com/kubernetes-incubator/service-catalog) & [Ansible Service Broker](https://github.com/fusor/ansible-service-broker) in a local or EC-2 environment.


For an overview of Ansible Service Broker and Ansible Playbook Bundles click [here](https://github.com/fusor/ansible-service-broker/blob/master/docs/introduction.md)

### Overview
These playbooks will:
  * Setup Origin through `oc cluster up`
  * Install [Service Catalog](https://github.com/kubernetes-incubator/service-catalog) on Origin
  * Install [Ansible Service Broker](https://github.com/fusor/ansible-service-broker) on Origin


### Local and EC-2 deployment options
  * To view individual Readme documents for these options click below
  * [Local Linux deployment](local/linux/README.md)
  * [Local macOS deployment](local/mac/README.md)
  * [EC-2 deployment](ec2/README.md)
