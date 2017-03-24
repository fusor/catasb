# Service Catalog x Ansible Service Broker

libvirt vagrant environment for working with a service-catalog/broker.

Service Catalog: https://github.com/kubernetes-incubator/service-catalog

Ansible Service Broker: https://github.com/fusor/ansible-service-broker

## About

Broken into two stages, stage1 box installs and configures a basic static
environment with required packages and one-off binaries, as well as setting
up and enabling a docker daemon. stage2 brings up a cluster, installs the
catalog, brings up a broker, and configures `catctl` to point directly
at the catalog for using new resources like brokers and serviceclasses.

### Roadmap

Expecting to add the following:

* Making assets like binaries and the stage1 box available
from a centralized location. Optionally, you can build, install, and set a
local stage1 box in the stage2 Vagrantfile.

* Adding switch to run a non-containerized broker on the vm via shared
directory for easy broker development workflow + scripts to reset catalog.

**TODO:**
Broker route is not going to work from the service catalog, since the route
resolves to `127.0.0.1`. Probably want to configure the router to use
a public ip of the vagrant machine or the internal service address of
the running ASB.

### Stage1

#### Binaries

* `kubectl v1.6.0-beta.4`, must be > 1.5.3
* `oc v3.6.0-alpha.0+0343989`
* `oadm v3.6.0-alpha.0+0343989`
* `glide v0.12.3`

By default these will be downloaded, but if `bin/` on the level of the
Vagrantfile, it will attempt to copy these binaries from the `/shared` mount.

#### Building/using stage1 box

**NOTE:** By default, this is not required. A first vagrant up of the stage2
vm will pull a remote stage1 and cache it for subsequent ups. If anything
is customized in the stage1 box however, a stage1 rebuild/`vagrant box add` is
required.

Building:

```
cd stage1 && vagrant up
vagrant halt
sudo chmod a+r /var/lib/libvirt/images/stage1_default.img # Whatever img was created
vagrant package --output catasb.stage1.box
vagrant box add ./catasb.stage1.box --name catasb.stage1
```

To use this box, update the base box in stage2 Vagrantfile to be whatever name
was used in the above `vagrant box add` cmd.

### Stage2

* Launches openshift cluster via `oc cluster up`
* Adds user with required permissions for the ASB to operate (default: admin/admin)
* Deploys the service catalogs apiserver/controller-manager service-catalog project.
By default, pre-built canary images will be pulled. Alternatively, they can be
built from master with `BUILD_CATALOG=1` env var.
* `catctl` is setup as an alias for controlling the service-catalog. It's
`kubectl` with a `kubeconfig` setup to point to the apiserver directly.
* ASB is launched in the `ansible-service-broker` project and
[bootstrapped](https://github.com/fusor/ansible-service-broker/blob/master/docs/design.md).

#### Running

The Ansible Service Broker requires a dockerhub user/pass to discover the apb
inventory. The `DOCKERHUB_USER` and `DOCKERHUB_PASS` env vars are required.

`cd stage2 && vagrant up`

## Networking Defaults

Default vagrant machine: `192.168.67.2` - MACHINE_IP stage{1,2) Vagrantfile

Docker bridge: `172.22.0.1/16` - DOCKER_BRIDGE stage1 Vagrantfile, requires
box rebuild.

Cluster overlay: `172.30.0.0/16`, currently no easy override, if changed
changed, requires stage1 provision.sh update to insecure registry and box rebuild.
