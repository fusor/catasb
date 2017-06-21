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
      2.3.0.0
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
      2.3.0.0
      ```
  * Install python dependencies
    ```bash
    $ pip install six
    ```

### Execute
  * Copy `local/config/my_vars.yml.example` to `local/config/my_vars.yml` and edit as needed.  You can use the `my_vars.yml` to override any settings.  For example:
    ```bash
    $ cp local/config/my_vars.yml.example local/config/my_vars.yml
    $ vim local/config/my_vars.yml
    ```
    * Set `dockerhub_user_name` (and optionally `dockerhub_user_password`) with your own dockerhub username (and password).  This will skip the prompts during execution and makes re-runs easy. A valid dockerhub login is required for the broker to authenticate to dockerhub to search an organization for APBs.
    * Set `dockerhub_org_name` to load APB images into your broker from an organization.  For dockerhub organization you may use your own if you pushed your own APBs or you may use the `ansibleplaybookbundle` [organization](https://hub.docker.com/u/ansibleplaybookbundle/) as a sample.
    * Set `openshift_hostname` and `dockerhub_org_name` if you want to use a different static IP.
    * Example `my_vars.yml`
          $ cat local/config/my_vars.yml
          ---

          dockerhub_user_name: foo@bar.com
          # dockerhub_user_password: changeme  # if commented out, will prompt
          dockerhub_org_name: ansibleplaybookbundle
  * Navigate to the `local/linux` folder and run the script to set up OpenShift.
    ```bash
    $ cd local/linux
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

### Testing downstream images
  * Use the --rcm flag. For instance:
    * `./run_setup_local.sh --rcm`
    * `./reset_environment.sh --rcm`

### Tested with
  * ansible 2.3.0.0
    * Problems were seen using ansible 2.2 and lower
