### Overview
These playbooks will do the following in a local environment:
  * Setup Origin through `oc cluster up`
  * Install [Service Catalog](https://github.com/kubernetes-incubator/service-catalog) on Origin

### Usage
Deploying the gate environment will provide *only* an openshift cluster with the
service-catalog so that when we add the broker it's the latest code.

To attach the broker, create the broker resource in the catlog by
running the following inside the ansible-service-broker repo:
```oc create -f ./scripts/broker-ci/broker-resource.yaml```

Finally, the ansible-service-broker can be deployed either by:
- Building the the ansible-service-broker container with ```make build-image```
  and deploying with ```make deploy```
- Running the broker locally with ```make run```.
