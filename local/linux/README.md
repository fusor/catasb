# CATalogASB Local Deployment

### Overview
These playbooks will do the following in a local environment:
  * Setup Origin through `oc cluster up`
  * Install [Service Catalog](https://github.com/kubernetes-incubator/service-catalog) on Origin
  * Install [Ansible Service Broker](https://github.com/openshift/ansible-service-broker) on Origin

### Pre-Reqs
  * Docker installed and configured

    * Suggestion, to ease usage we allow our regular user to access the docker server by doing the below:

      * ```sudo groupadd docker```
      * ```sudo usermod -aG docker $USER```
      * ```sudo systemctl restart docker```

  * Follow install instructions from ```oc cluster up``` documentation
    * https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md#linux

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
  * Copy `config/my_vars.yml.example` to `config/my_vars.yml` and edit as needed.  You can use the `my_vars.yml` to override any settings.  For example:
    ```bash
    $ cp config/my_vars.yml.example config/my_vars.yml
    $ vim config/my_vars.yml
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


### Troubleshooting

#### pull() got an unexpected keyword argument 'decode'

```
Error pulling image docker.io/ansibleplaybookbundle/ansible-service-broker-apb:summit - pull() got an unexpected keyword argument 'decode'
```

This is a problem with having docker-py installed, and at a specific version. More info in https://github.com/ansible/ansible-modules-core/issues/5515.
The recommended fix for this is to uninstall docker-py, as there is an ansible task for installing docker using pip.

```
<sudo> pip uninstall docker-py
```

#### APBs not visible from OpenShift Web UI

In some cases APBs won't be visible from the OpenShift Console after `./run_setup_local.sh`.
This can happen when the catalog is unable to talk to the broker due to an issue with iptables.

The recommended fix is to flush iptables rules and reset the catasb environment.
```
sudo iptables -F
./reset_environment.sh
```

#### Cannot connect to the Docker daemon. Is the docker daemon running on this host

```
TASK [openshift_setup : Resetting cluster, True]
 ****************
"error: cannot communicate with Docker"
```

This may be a permission issue, we recommend relaxing permissions on docker so your regular user is able to access docker.  The following will allow your regular user to access docker:

  * ```sudo groupadd docker```
  * ```sudo usermod -aG docker $USER```
  * ```sudo systemctl restart docker```

#### sudo: a password is required

```
TASK [openshift_setup : Resetting cluster, True] *********************************************************************************************************************************************************
changed: [localhost]

TASK [openshift_setup : Install docker through pip as it's a requirement of ansible docker module] *******************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "failed": true, "module_stderr": "sudo: a password is required\n", "module_stdout": "", "msg": "MODULE FAILURE", "rc": 1}
	to retry, use: --limit @/home/tsanders/Workspace/catasb/ansible/setup_local_environment.retry
TASK [openshift_setup : Resetting cluster, True] *********************************************************************************************************************************************************
changed: [localhost]

TASK [openshift_setup : Install docker through pip as it's a requirement of ansible docker module] *******************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "failed": true, "module_stderr": "sudo: a password is required\n", "module_stdout": "", "msg": "MODULE FAILURE", "rc": 1}
	to retry, use: --limit @/home/tsanders/Workspace/catasb/ansible/setup_local_environment.retry

```

We currently run with NOPASSWD configured for sudo, to do the same:

  * ```sudo visudo```
  * Add this line:

      ```
      %wheel  ALL=(ALL)       NOPASSWD: ALL
      ```

#### Error: did not detect an --insecure-registry argument on the Docker daemon

```
TASK [openshift_setup : Run oc cluster up] ***************************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": true, "cmd": "/home/tsanders/bin/oc cluster up --routing-suffix=172.17.0.1.nip.io --public-hostname=172.17.0.1 --host-pv-dir=/persistedvolumes --version=latest --host-config-dir=/var/lib/origin/openshift.local.config", "delta": "0:00:00.136821", "end": "2017-06-26 10:32:31.792848", "failed": true, "rc": 1, "start": "2017-06-26 10:32:31.656027", "stderr": "", "stderr_lines": [], "stdout": "Starting OpenShift using openshift/origin:latest ...\n-- Checking OpenShift client ... OK\n-- Checking Docker client ... OK\n-- Checking Docker version ... OK\n-- Checking for existing OpenShift container ... OK\n-- Checking for openshift/origin:latest image ... OK\n-- Checking Docker daemon configuration ... FAIL\n   Error: did not detect an --insecure-registry argument on the Docker daemon\n   Solution:\n\n     Ensure that the Docker daemon is running with the following argument:\n     \t--insecure-registry 172.30.0.0/16", "stdout_lines": ["Starting OpenShift using openshift/origin:latest ...", "-- Checking OpenShift client ... OK", "-- Checking Docker client ... OK", "-- Checking Docker version ... OK", "-- Checking for existing OpenShift container ... OK", "-- Checking for openshift/origin:latest image ... OK", "-- Checking Docker daemon configuration ... FAIL", "   Error: did not detect an --insecure-registry argument on the Docker daemon", "   Solution:", "", "     Ensure that the Docker daemon is running with the following argument:", "     \t--insecure-registry 172.30.0.0/16"]}
	to retry, use: --limit @/home/tsanders/Workspace/catasb/ansible/setup_local_environment.retry

PLAY RECAP ***********************************************************************************************************************************************************************************************
localhost                  : ok=25   changed=4    unreachable=0    failed=1   
```

There are several configurations required to run ```oc cluster up```, please be sure to read and follow the ``` oc cluster up``` documentation here:  https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md#linux
