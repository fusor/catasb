# Kubernetes Setup

### Overview
The Kubernetes playbooks will:
  * Setup a Kubernete cluster with kubeadm
  * Deploy the service-catlog
  * Deploy the ansible-service-broker

### First Run
The first time you run the Kubernetes playbook localy be sure to use
'run_setup_local.sh'.  The Kubernetes playbook installs a number of packages
that will be required to setup the cluster.

### Config Option
Running the local scripts require either -k or k8s or kubernetes. Or set the
ansible variable 'cluster="kubernetes"'.
```
   ./reset-environment.sh -k
```

### Disable Firewalld
In order to allow Kubernetes dns to get a locally accessable enpoint,
**disable firewalld**. Otherwise you will see the kube-dns pod fail and the
following rules will appear in iptables:
```
$ sudo iptables -L
Chain KUBE-SERVICES (2 references)
num  target     prot opt source               destination
1    REJECT     tcp  --  anywhere             10.96.0.10           /* kube-system/kube-dns:dns-tcp has no endpoints */ tcp dpt:domain reject-with icmp-port-unreachable
2    REJECT     udp  --  anywhere             10.96.0.10           /* kube-system/kube-dns:dns has no endpoints */ udp dpt:domain reject-with icmp-port-unreachable
```

### Using The Proper Context
If you are seeing issues with accessing the service-catalog resources, be sure
you are using the correct context.

```
Error from server User: asb cannot list servicebrokers.serviceclasses...
```

Check your current context:
```
kubectl config current-context
```

To have proper permission to access the catalog, use
```kubernetes-admin@kubernetes```.
```
kubectl config set-context kubernetes-admin@kubernetes
```

### Tip and Tricks
Kubeadm has it's own CLI and preflight checks.  If you're having issues with
the kubeadm command run it by hand.

```
sudo kubeadm init
```

For cleanup:

```
sudo kubeadm reset
```
