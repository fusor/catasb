# CATalogASB EC-2 Deployment

catasb is a collection of playbooks to create an OpenShift environment with a Service Catalog & Ansible Service Broker in EC-2.

### Overview
These playbooks will:
  * Create a public VPC if it does not exist
  * Create a security group if it does not exist
  * Create an instance with a specific Name if does not exist
  * Associate an elastic ip to instance
  * Configure a hostname with elastic ip through Route53
  * Setup Origin through `oc cluster up`
  * Install Service Catalog on Origin
  * Install Ansible Service Broker on Origin

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
  * Install python dependencies (This is needed for python2. Use pip2 if using python3)
    ```bash
    $ pip install boto boto3 six
    ```
  * Configure a SSH Key in your AWS EC-2 account for the given region
  * Create a hosted zone in Route53
  * Set these environment variables:
    ```bash
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    AWS_SSH_PRIV_KEY_PATH  - Path to your private ssh key to use for the ec2 instances
    ```

### Execute
  * Navigate to the `ec2` folder
    ```bash
    $ cd catasb/ec2
    ```
  * Edit the variables file `ec2/common_vars`
    * Note the following and update:
      ```bash
      AWS_SSH_KEY_NAME="splice"
      TARGET_DNS_ZONE="ec2.dog8code.com"
      ```
      Needs to match a hosted zone entry in your Route53 account, we will create a subdomain under it for the ec2 instance
  * To make re-runs easy, create a `my_vars.yml` with your dockerhub credentials
    * `cp my_vars.yml.example my_vars.yml`
    * Replace with your dockerhub username/password
     * Valid dockerhub login is required for the broker to authenticate to dockerhub to search an organization for APBs.
    * For dockerhub organization you may use your own if you pushed APBs to it or you may use: `ansibleplaybookbundle`
       * https://hub.docker.com/u/ansibleplaybookbundle/
    * Example `my_vars.yml`

          $ cat my_vars.yml
          ---

          dockerhub_user_name: foo@bar.com
          dockerhub_user_password: changeme
          dockerhub_org_name: ansibleplaybookbundle
  * Create our infrastructure in ec2 if it doesn't exist
    ```bash
    $ ./run_create_infrastructure.sh
    ```
  * Run the setup script
    ```bash
    $ ./run_setup_environment.sh
    ```
  * Open a Web Browser
    * Visit: `https://apiserver-service-catalog.USERNAME.ec2.dog8code.com`
      * Accept the SSL certificate for the apiserver-service-catalog endpoint
      * Ignore the text that appears and proceed to the main OpenShift URL next
      * Note: must accept the new SSL cert, each time you reset your OpenShift environment
    * Visit: `https://<USERNAME>.ec2.dog8code.com:8443`
      * Where `<USERNAME>` is the value of `whoami` when you launched `run_setup_environment.sh`

### Cleanup

* To terminate the ec2 instance and cleanup the associated EBS volumes run the below
  ```bash
  $ ./terminate_instance.sh
  ```

* To reset the ec2 instance back to clean origin and deployment of ASB and Service Catalog run the below
  ```bash
  $ ./reset_environment.sh
  ```

### Testing downstream images
  * Use the --rcm flag. For instance:
    * `./run_setup_envrironment.sh --rcm`
    * `./reset_environmet.sh --rcm`

### Tested with
  * ansible 2.3.0.0
    * Problems were seen using ansible 2.2 and lower
