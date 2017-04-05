#!/bin/sh --login

subscription-manager register --username="qa@redhat.com" --password="uuV4gQrtG7sfMP3q"
if [ "$?" -ne "0" ]; then
  echo "Error trying to register with subscription-manager"
  exit
fi

subscription-manager attach --pool=8a85f9823e3d5e43013e3ddd4e2a0977
if [ "$?" -ne "0" ]; then
  echo "Error trying to auto attach pool for employee sku"
  exit
fi

echo '****************** Enabling Required Repos ******************'

# Only use necessary repos
subscription-manager repos --disable "*"
if [ "$?" -ne "0" ]; then
  echo "Error disabling repos"
  exit
fi

subscription-manager repos --enable rhel-7-server-rpms
if [ "$?" -ne "0" ]; then
  echo "Error enabling repo rhel-7-server-rpms"
  exit
fi

subscription-manager repos --enable rhel-7-server-extras-rpms
if [ "$?" -ne "0" ]; then
  echo "Error enabling repo rhel-7-server-extras-rpms"
  exit
fi

subscription-manager repos --enable rhel-7-server-optional-rpms
if [ "$?" -ne "0" ]; then
  echo "Error enabling repo rhel-7-server-optional rpms"
  exit
fi

subscription-manager repos --enable rhel-7-server-ose-3.4-rpms
if [ "$?" -ne "0" ]; then
  echo "Error enabling repo rhel-7-server-ose-3.4-rpms"
  exit
fi

yum clean all
yum -y update
yum -y install deltarpm

yum -y install wget git net-tools bind-utils bridge-utils gcc docker vim ansible atomic-openshift golang

/bin/easy_install pip

groupadd docker
gpasswd -a vagrant docker

sed -i "s/OPTIONS='--selinux-enabled/OPTIONS='--selinux-enabled --insecure-registry 172.30.0.0\/16/g" /etc/sysconfig/docker  
sed -i "s/DOCKER_NETWORK_OPTIONS=/DOCKER_NETWORK_OPTIONS='--bip=172.16.0.1\/16'/g" /etc/sysconfig/docker-network
ifdown eth1
ifup eth1
systemctl enable docker; systemctl start docker


wget https://github.com/openshift/origin/releases/download/v1.5.0-alpha.3/openshift-origin-client-tools-v1.5.0-alpha.3-cf7e336-linux-64bit.tar.gz -O /tmp/oc.tar.gz

tar -xzf /tmp/oc.tar.gz -C /tmp
mv /tmp/openshift-origin-client-tools-v1.5.0-alpha.3-cf7e336-linux-64bit/oc /usr/local/bin/

MAC_ADDRESS=$(ifconfig eth0 | grep ether | awk '{print $2}')
CLUSTER_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/$MAC_ADDRESS/public-hostname)

/usr/local/bin/oc cluster up --routing-suffix=ocp.ec2.dog8code.com --public-hostname=ocp.ec2.dog8code.com
/shared/provision.sh $CLUSTER_HOSTNAME dymurray qci-test
