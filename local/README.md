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
            2.2.2.0
    * MacOS requires Ansible to be installed from `pip` and not `brew`
          $ python -c "import ansible;print(ansible.__version__)"
          Traceback (most recent call last):
          File "<string>", line 1, in <module>
          ImportError: No module named ansible

          brew uninstall ansible
          pip install ansible

          $ python -c "import ansible;print(ansible.__version__)"
          2.2.2.0
  * Install python dependencies
     * `pip install six`

### Execute
  * `cd local`
  * Edit the variables file `local/common_vars`
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
  * `cd local`
  * `./reset_environment.sh`

### Tested with
  * ansible 2.2.2.0 & 2.3.0.0
    * Problems were seen using ansible 2.0
