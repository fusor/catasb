# CatASB EC2 Deployment

OpenShift environment with a Service Catalog & Ansible Service Broker in a single EC2 Instance.

## Overview

These playbooks will:

* Create a public VPC if it does not exist
* Create a security group if it does not exist
* Create a single EC2 instance with a specific Name if does not exist
* Associate an elastic ip to instance
* Configure a hostname with elastic ip through Route53
* Setup *Origin* through `oc cluster up`
* Install Service Catalog on *Origin*
* Install Ansible Service Broker on *Origin*

## Pre-Reqs
* Ansible 2.4.0+ installed.
* Ansible needs to be installed so its source code is available to Python.
  * Check to see if Ansible modules are available to Python
    ```bash
    $ python -c "import ansible;print(ansible.__version__)"
    2.4.1.0
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
    2.4.1.0
    ```
* Install python dependencies (This is needed for python2. Use pip2 if using python3)
  * On Fedora and EL7 it is recommended that you use ansible in a python virtualenv.
    * This is due to a couple reasons:
      * boto rpms are not sufficiently new enough
      * pip is not sudo safe on Fedora and EL7
    * To setup and active a virtualenv do the following;
    ```bash
    sudo dnf install python-virtualenv #or EL7: sudo yum install python-virtualenv
    virtualenv /tmp/ansible
    source /tmp/ansible/bin/activate
    pip install ansible
    ```
  * Continue with the next step:
    ```bash
    $ pip install boto boto3 six
    ```

* Configure a SSH Key in your AWS EC2 account for the given region
* Create a hosted zone in Route53
* Set these environment variables:

  ```bash
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  AWS_SSH_PRIV_KEY_PATH  - Path to your private ssh key to use for the ec2 instances
  ```

## Execute

* Navigate to the [config](../../config) folder
  ```bash
  $ cd catasb/config
  ```
* Edit the variables file [ec2_env_vars](../../ec2_env_vars)
  * Note the following and update:
    ```bash
    AWS_SSH_KEY_NAME="splice"
    TARGET_DNS_ZONE="ec2.dog8code.com"
    ```
    Needs to match a hosted zone entry in your Route53 account, we will create a subdomain under it for the ec2 instance
* Create a `catasb/config/my_vars.yml`
  ```bash
  $ cp catasb/config/my_vars.yml.example catasb/config/my_vars.yml
  ```
  Override any variables you see in the `my_vars.yml` files as necessary (e.g. dockerhub_org)
* Navigate to the `ec2/minimal` folder
  ```bash
  $ cd catasb/ec2/minimal
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

## Cleanup

* To terminate the ec2 instance and cleanup the associated EBS volumes run the below
  ```bash
  $ ./terminate_instance.sh
  ```
* To reset the ec2 instance back to clean origin and deployment of ASB and Service Catalog run the below
  ```bash
  $ ./reset_environment.sh
  ```

## Testing downstream images
  * Use the --rcm flag. For instance:
    * `./run_setup_envrironment.sh --rcm`
    * `./reset_environmet.sh --rcm`

## Tested with
  * ansible 2.4.1.0
    * Problems were seen using ansible 2.2 and lower
