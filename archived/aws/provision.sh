CLUSTER_IP=$1
DOCKERHUB_USER=$2
DOCKERHUB_PASS=$3
CLUSTER_USER=admin
GOPATH=/home/ec2-user
KUBE_INCUBATOR_DIR=$GOPATH/src/github.com/kubernetes-incubator
SERVICE_CAT_REPO=https://www.github.com/kubernetes-incubator/service-catalog.git
SERVICE_CAT_DIR=$KUBE_INCUBATOR_DIR/service-catalog
APISERVER_IMG="quay.io/kubernetes-service-catalog/apiserver:canary"
CONTROLLER_MANAGER_IMG="quay.io/kubernetes-service-catalog/controller-manager:canary"

# Launch oc cluster up create user with cluster root
/shared/create_cluster_user.sh $CLUSTER_USER

# Build or pull existing apiserver/controller-manager images
if [[ -n "$BUILD_CATALOG" ]]; then
  echo "============================================================"
  echo "SERVICE CATALOG: Building from source..."
  echo "============================================================"
  mkdir -p $KUBE_INCUBATOR_DIR
  git clone $SERVICE_CAT_REPO $SERVICE_CAT_DIR
  cd $SERVICE_CAT_DIR
  NO_DOCKER=1 make apiserver-image controller-manager-image
else
  echo "============================================================"
  echo "SERVICE CATALOG: Pulling from dockerhub..."
  echo "============================================================"
  docker pull $APISERVER_IMG
  docker pull $CONTROLLER_MANAGER_IMG
  docker tag $APISERVER_IMG apiserver:canary
  docker tag $CONTROLLER_MANAGER_IMG controller-manager:canary
fi

# Deploy service-catalog
oc new-project service-catalog
oc process -f /shared/service-catalog.templ.yaml | oc create -f -

# TODO: This is bad. HACK: Wait until apiserver is up
# Tap into cluster events somehow?
until oc get pods | grep -qiEm1 "apiserver.*?running"; do : ; done
# Get apiserver ip address
API_SRV_IP=$(/shared/get_apiserver_ip.sh)
SERVICE_CAT_ENDPOINT="$API_SRV_IP:8081"
echo "Service Catalog Endpoint: $SERVICE_CAT_ENDPOINT"
mkdir -p /home/ec2-user/.kube
cat /shared/kubeconfig.templ.yaml | sed "s|{{SERVICE_CATALOG_ENDPOINT}}|$SERVICE_CAT_ENDPOINT|" \
  > /home/ec2-user/.kube/service-catalog.config
chown -R ec2-user:ec2-user /home/ec2-user/.kube

# Bring up broker
mkdir -p $GOPATH/src/github.com/fusor
cd $GOPATH/src/github.com/fusor
git clone https://github.com/fusor/ansible-service-broker.git
cd ansible-service-broker/scripts/asbcli
git checkout forced-async-prov
pip install -r ./requirements.txt
./asbcli up $CLUSTER_IP:8443 \
  --cluster-user=admin --cluster-pass=admin \
  --dockerhub-user=$DOCKERHUB_USER --dockerhub-pass=$DOCKERHUB_PASS

oc project ansible-service-broker
until oc get pods | grep -iEm1 "asb.*?running" | grep -v deploy; do : ; done
until oc get pods | grep -iEm1 "etcd.*?running" | grep -v deploy; do : ; done
sleep 20

ASB_ROUTE=$(oc get routes | grep ansible-service-broker | awk '{print $2}')
echo "Ansible Service Broker Route: $ASB_ROUTE"
echo "Bootstrapping broker..."
curl -X POST $ASB_ROUTE/v2/bootstrap
echo "Successfully bootstrapped broker!"
echo "export ASB_ROUTE=$ASB_ROUTE" >> /etc/profile
cat /shared/broker.templ.yaml | sed "s|{{ASB_ROUTE}}|$ASB_ROUTE|" \
  > /home/ec2-user/broker.yaml

cd /home/ec2-user
# Download kubectl 1.6 and move to bin
curl -o kubectl https://storage.googleapis.com/kubernetes-release/release/v1.6.0-beta.3/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/bin/

echo "============================================================"
echo "Cluster: $CLUSTER_IP:8443"
echo "Broker User: $CLUSTER_USER"
echo "Service Catalog API Server: $SERVICE_CAT_ENDPOINT"
echo "Ansible Service Broker: $ASB_ROUTE"
echo ""
echo "\`catctl\` is an alias for kubctl using a kubeconfig that is connected"
echo "to the service catalog directly. See ~/.kube/service-catalog.config"
echo ""
echo "To log into cluster:"
echo "$ oc login $CLUSTER_IP:8443 -u $CLUSTER_USER -p $CLUSTER_USER"
echo ""
echo "To connect the broker to the catalog:"
echo "$ catctl create -f ~/broker.yaml"
echo ""
echo "Successfully setup oc completion!"
echo "============================================================"

# Setup alias to use service-catalog apiserver with kubectl
cp /shared/catctl.profile.sh /etc/profile.d
echo "source <(oc completion bash)" > /home/ec2-user/.bash_profile
