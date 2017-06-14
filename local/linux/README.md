# CATalogASB Local Deployment

catasb is a collection of playbooks to create an OpenShift environment with a Service Catalog & Ansible Service Broker in a local environment.

### Overview
These playbooks will:
  * Setup Origin through `oc cluster up`
  * Install Service Catalog on Origin
  * Install Ansible Service Broker on Origin

### Pre-Reqs
  * Ansible needs to be installed so its source code is available to Python.
    * Check to see if Ansible modules are available to Python

          $ python -c "import ansible;print(ansible.__version__)"
          2.3.0.0
    * MacOS requires Ansible to be installed from `pip` and not `brew`
          $ python -c "import ansible;print(ansible.__version__)"
          Traceback (most recent call last):
          File "<string>", line 1, in <module>
          ImportError: No module named ansible

          brew uninstall ansible
          pip install ansible

          $ python -c "import ansible;print(ansible.__version__)"
          2.3.0.0
  * Install python dependencies
     * `pip install six`

### Execute
  * `cd local/linux`
  * Edit the variables file `common_vars`
    * Update:
      * CLUSTER_IP if your installation of Docker is not using the default bridge of `docker0`
  * `./run_setup_local.sh`
    * Sets up OpenShift
  * In Web Browser
    * Visit: `https://apiserver-service-catalog.CLUSTERIP.nip.io`
      * Accept the certificate
      * You will see some text on the screen, ignore this and proceed to the main openshift URL next
       * Point of this step is just to accept the SSL cert for the apiserver-service-catalog endpoint
    * Visit: `https://CLUSTERIP.nip.io:8443`

### Cleanup

To terminate the local instance run the below
  * `oc cluster down`

To reset the environment to a clean instance of origin with ASB and Service Catalog run the below
  * `cd local/linux`
  * `./reset_environment.sh`

### Tested with
  * ansible 2.3.0.0
    * Problems were seen using ansible 2.0

### Troubleshooting

**pull() got an unexpected keyword argument 'decode'**

```
Error pulling image docker.io/ansibleplaybookbundle/ansible-service-broker-apb:summit - pull() got an unexpected keyword argument 'decode'
```

This is a problem with having docker-py installed, and at a specific version. More info in https://github.com/ansible/ansible-modules-core/issues/5515.
The recommended fix for this is to uninstall docker-py, as there is an ansible task for installing docker using pip.

```
<sudo> pip uninstall docker-py
```

**APBs not visible from OpenShift Web UI**

In some cases APBs won't be visible from the OpenShift Console after `./run_setup_local.sh`.
This can happen when the catalog is unable to talk to the broker due to an issue with iptables.

The recommended fix is to flush iptables rules and reset the catasb environment.
```
sudo iptables -F
./reset_environment.sh
```
