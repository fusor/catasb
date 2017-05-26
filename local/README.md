# CATalogASB Local Deployment

### Overview
These playbooks will do the following in a local environment:
  * Setup Origin through `oc cluster up`
  * Install [Service Catalog](https://github.com/kubernetes-incubator/service-catalog) on Origin
  * Install [Ansible Service Broker](https://github.com/fusor/ansible-service-broker) on Origin

### Pre-Reqs
  * Ansible needs to be installed so its source code is available to Python.
    * Check to see if Ansible modules are available to Python
      ```bash
      $ python -c "import ansible;print(ansible.__version__)"
      2.2.2.0
      ```
    * MacOS requires Ansible to be installed from `pip` and not `brew`
      ```bash
      $ python -c "import ansible;print(ansible.__version__)"
      Traceback (most recent call last):
      File "<string>", line 1, in <module>
      ImportError: No module named ansible

      brew uninstall ansible
      pip install ansible

      $ python -c "import ansible;print(ansible.__version__)"
      2.2.2.0
      ```
  * Install python dependencies
    ```bash
    $ pip install six
    ```

### Execute
  * Navigate to the `local` folder
    ```bash
    $ cd catasb/local
    ```
  * Edit the variables file `common_vars`
    * Note: `CLUSTER_IP` assumes that the default bridge of `docker0` is being used
    * Optional: Edit the variables file `my_vars`
      ```bash
      $ more my_vars
      export DOCKERHUB_USER_NAME="docker_user_name"
      export DOCKERHUB_USER_PASSWORD="my_password"
      export DOCKERHUB_ORG_NAME="my_org"
      ```

  * Run the setup script
    ```bash
    $ ./run_setup_local.sh
    ```
  * Open a Web Browser
    * Visit: `https://apiserver-service-catalog.CLUSTERIP.nip.io`
      * Accept the SSL certificate for the apiserver-service-catalog endpoint
      * Ignore the text that appears and proceed to the main OpenShift URL next
      * Note: must accept the new SSL cert, each time you reset your OpenShift environment
    * Visit: `https://<CLUSTERIP>.nip.io:8443`
      * The <CLUSTERIP> is the same as the one you set in `common_vars`

### Cleanup

* To terminate the local instance run the below
  ```bash
  $ oc cluster down
  ```

* To reset the environment to a clean instance of origin with ASB and Service Catalog run the below
  ```bash
  $ ./reset_environment.sh
  ```

### Tested with
  * ansible 2.2.2.0 & 2.3.0.0
    * Problems were seen using ansible 2.0
