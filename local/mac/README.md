# CATalogASB Local Deployment

catasb is a collection of playbooks to create an OpenShift environment with a Service Catalog & Ansible Service Broker in a local environment.

### Overview
These playbooks will:
  * Setup Origin through `oc cluster up`
  * Install Service Catalog on Origin
  * Install Ansible Service Broker on Origin

### Pre-Reqs
  * ```socat``` needs to be installed

        	brew install socat

  * We can NOT work with latest Docker for Mac.
  * Older version of Docker for Mac needs to be installed
      * https://download.docker.com/mac/stable/1.12.6.14937/Docker.dmg
      * Info on issues seen:
          * Error syncing pod, skipping: failed to "StartContainer" for "POD" with RunContainerError: "runContainer: docker: failed to parse docker version \"17.03.1-ce\": illegal zero-prefixed version component \"03\" in \"17.03.1-ce\""
              * https://github.com/openshift/origin/pull/13201
              * https://github.com/docker/for-mac/issues/1491
  * Docker setup:
     * de-select check for updates
     * Insecure Registry setting needed 172.30.0.0/16
     * Shared Folders (create these folders on your mac owned by your user)
         * /docker_shared/origin
         * /persistedvolumes
  * Networking Setup
      * We will create a static IP aliased to lo0 automatically.  We are using the static IP address to ensure that we can always resolve openshift from the host as well as inside of containers.
      * The local/mac/env_vars script will create a local alias automatically by running the below.

                  sudo ifconfig lo0 alias 192.168.37.1

  * Recommended way to install Ansible
      * We recommend you install Ansible from pip instead of homebrew
      * This will ensure Ansible is in the python path
          * MacOS example Ansible to be installed from `pip` and not `brew`
              * From homebrew we see:

                        $ python -c "import ansible;print(ansible.__version__)"
                        Traceback (most recent call last):
                        File "<string>", line 1, in <module>
                        ImportError: No module named ansible

                        brew uninstall ansible
                        pip install ansible

                        $ python -c "import ansible;print(ansible.__version__)"
                        2.3.0.0

### Notes
  * Accessing the VM on OSX running docker:
     * screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
  * Performance Issues:
    * Shared Volume issues
        * https://github.com/docker/for-mac/issues/668
    * After mac host has been resumed (closed lid or went to sleep) the performance seems worse with oc commands
        * Doing a reset_environment.sh brings things back to be better.

### Execute
  * Copy `local/config/my_vars.yml.example` to `local/config/my_vars.yml` and edit as needed.  You can use the `my_vars.yml` to override any settings.  For example:
    ```bash
    $ cp ../config/my_vars.yml.example ../config/my_vars.yml
    $ vim ../config/my_vars.yml
    ```
    * Set `dockerhub_user_name` (and optionally `dockerhub_user_password`) with your own dockerhub username (and password).  This will skip the prompts during execution and makes re-runs easy. A valid dockerhub login is required for the broker to authenticate to dockerhub to search an organization for APBs.
    * Set `dockerhub_org_name` to load APB images into your broker from an organization.  For dockerhub organization you may use your own if you pushed APBs or you may use the `ansibleplaybookbundle` [organization](https://hub.docker.com/u/ansibleplaybookbundle/) as a sample.
    * Set `openshift_hostname` and `dockerhub_org_name` if you want to use a different static IP.
    * Example `my_vars.yml`
          $ cat ../config/my_vars.yml
          ---

          dockerhub_user_name: foo@bar.com
          # dockerhub_user_password: changeme  # if commented out, will prompt
          dockerhub_org_name: ansibleplaybookbundle
  * Navigate to the `local/mac` folder and run the script to set up OpenShift.
    ```bash
    $ cd local/mac
    $ ./run_mac_local.sh
    ```
  * In Web Browser
    * Visit: `https://apiserver-service-catalog.CLUSTERIP.nip.io`
      * Accept the certificate
      * You will see some text on the screen, ignore this and proceed to the main openshift URL next
       * Point of this step is just to accept the SSL cert for the apiserver-service-catalog endpoint
    * Visit: `https://CLUSTERIP.nip.io:8443`

### Bind Example
  * Sample workflow showing how to create python webapp binding to a local postgres database
    * Sample python web app to use:
      * https://github.com/fusor/awsdemo.git
    * Youtube Video showing workflow:
      * https://www.youtube.com/watch?v=xmd52NhEjCk

### Cleanup

To terminate the local instance run the below
  * `oc cluster down`

To reset the environment to a clean instance of origin with ASB and Service Catalog run the below
  * `cd local/mac`
  * `./reset_environment.sh`

### Testing downstream images
  * Use the --rcm flag. For instance:
    * `./run_setup_local.sh --rcm`
    * `./reset_environment.sh --rcm`

### Tested with
  * ansible 2.3.0.0
    * Problems were seen using ansible 2.2 and lower
