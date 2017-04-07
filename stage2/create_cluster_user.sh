CLUSTER_USER=$1
SERVICE_CATALOG_USER=system:serviceaccount:service-catalog:default

# Create and configure user
oc login -u system:admin
oc create user $CLUSTER_USER
oadm policy add-cluster-role-to-user cluster-admin $CLUSTER_USER
oadm policy add-cluster-role-to-user cluster-admin $SERVICE_CATALOG_USER
oadm policy add-scc-to-user privileged $CLUSTER_USER
oadm policy add-scc-to-group anyuid system:authenticated
oc login -u $CLUSTER_USER -p $CLUSTER_USER
