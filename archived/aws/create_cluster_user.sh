CLUSTER_USER=$1

# Create and configure user
oc login -u system:admin
oc create user $CLUSTER_USER
oadm policy add-cluster-role-to-user cluster-admin $CLUSTER_USER
oadm policy add-scc-to-user privileged $CLUSTER_USER
oadm policy add-scc-to-group anyuid system:authenticated
oc login -u $CLUSTER_USER -p $CLUSTER_USER
