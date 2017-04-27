# CATalogASB

catasb is a collection of playbooks to create an OpenShift environment with a Service Catalog & Ansible Service Broker in a local or EC-2 environment.

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
     * `pip install boto boto3 six`

### Local and EC-2 deployment options
  * To view individual Readme documents for these two options click below
  * [Local deployment](local/README.md)
  * [EC-2 deployment](ec2/README.md)
