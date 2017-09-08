# CatASB with AWS
OpenShift with the Service Catalog and the Ansible Service Broker can be deployed in the [Amazon Web Services](https://aws.amazon.com/) (AWS) environment in the following configurations:

* [Minimal](./minimal)

    * Single EC-2 Instance
    * Installs [Origin](https://www.openshift.org/) via **`oc cluster up`**

* [Multi-Node](./multi_node)

<<<<<<< 2c493fc7ed3b9a7522cdcfb534b07257cc1b7f9e
      brew uninstall ansible
      pip install ansible

      $ python -c "import ansible;print(ansible.__version__)"
      2.3.0.0
      ```
  * Install python dependencies (This is needed for python2. Use pip2 if using python3)
    * On Fedora and EL7 it is recommended that you use ansible in a python virtualenv.
     * This is due to a couple reasons:
       - boto rpms are not sufficiently new enough
       - pip is not sudo safe on Fedora and EL7
     * To setup and active a virtualenv do the following;
     ```
     sudo dnf install python-virtualenv #or EL7: sudo yum install python-virtualenv
     virtualenv /tmp/ansible
     source /tmp/ansible/bin/activate
     pip install ansible
     ```
   * Continue with the next step:

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
  * Edit the variables file `../config/ec2_env_vars`
    * Note the following and update:
      ```bash
      AWS_SSH_KEY_NAME="splice"
      TARGET_DNS_ZONE="ec2.dog8code.com"
      ```
      Needs to match a hosted zone entry in your Route53 account, we will create a subdomain under it for the ec2 instance
  * To make re-runs easy, create a `catasb/config/my_vars.yml` with your dockerhub credentials
    * `cp catasb/config/my_vars.yml.example catasb/config/my_vars.yml`
    * Replace with your dockerhub username/password
      * A valid dockerhub login is required for the broker to authenticate to dockerhub to search an organization for APBs.
    * For dockerhub organization you may use your own if you pushed APBs to it or you may use: `ansibleplaybookbundle`
      * https://hub.docker.com/u/ansibleplaybookbundle/
    * Example `my_vars.yml`

          $ cat my_vars.yml
          ---

          dockerhub_user_name: foo@bar.com
          dockerhub_user_password: changeme
          dockerhub_org: ansibleplaybookbundle 
  * Navigate to the `ec2` folder
    ```bash
    $ cd catasb/ec2
    ```
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
=======
    * Multiple EC-2 Instances
    * Installs [OpenShift Container Platform](https://www.openshift.com/container-platform/index.html) or [Origin](https://www.openshift.org/) via [OpenShift Ansible](https://github.com/openshift/openshift-ansible)
    * Configurable Contents
        * RH CDN
        * Latest Mirror Repos
>>>>>>> update
