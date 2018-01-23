# CatASB with AWS

OpenShift with the Service Catalog and the Ansible Service Broker can be deployed in the [Amazon Web Services](https://aws.amazon.com/) (AWS) environment in the following configurations:

* [Minimal](./minimal)
  * Single EC-2 Instance
  * Installs [Origin](https://www.openshift.org/) via **`oc cluster up`**

* [Multi-Node](./multi_node)
  * Multiple EC-2 Instances
  * Installs [OpenShift Container Platform](https://www.openshift.com/container-platform/index.html) or [Origin](https://www.openshift.org/) via [OpenShift Ansible](https://github.com/openshift/openshift-ansible)
    * Configurable Contents
      * RH CDN
      * Latest Mirror Repos
