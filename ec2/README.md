# CatASB with AWS
Openshift can be deployed in the Amazon Web Services (AWS) environment in the following configurations

* [Minimal](./minimal)

    * Single EC-2 Instance
    * Installs Origin via **`oc cluster up`**

* [Multi-Node](./multi_node)

    * Multiple EC-2 Instances
    * Installs Openshift Enterprise via [Openshift Ansible](https://github.com/openshift/openshift-ansible)
    * Configurable Contents
        * RH CDN
        * Latest Mirror Repos
