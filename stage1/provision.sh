DOCKER_BRIDGE=$1
GOLANG_TAR="https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz"
REMOTE_BIN_PATH="http://ernelsondt.usersys.redhat.com:11080/catasb/stage1"

cp /shared/gopath.init.sh /etc/profile.d
source /etc/profile.d/gopath.init.sh

yum upgrade -y
yum install -y epel-release
yum install -y \
  docker net-tools bind-utils vim git hg gcc gcc-c++ btrfs-progs-devel \
  device-mapper-devel python python-pip

groupadd docker
gpasswd -a vagrant docker

if [[ -d "/shared/bin" ]]; then
  cp /shared/bin/{glide,oc,oadm,kubectl} /usr/bin
else
  curl -L "$REMOTE_BIN_PATH/oc" > /usr/bin/oc && chmod 755 /usr/bin/oc
  curl -L "$REMOTE_BIN_PATH/oadm" > /usr/bin/oadm && chmod 755 /usr/bin/oadm
  curl -L "$REMOTE_BIN_PATH/glide" > /usr/bin/glide && chmod 755 /usr/bin/glide
  curl -L "$REMOTE_BIN_PATH/kubectl" > /usr/bin/kubectl && chmod 755 /usr/bin/kubectl
fi

sed -i "s|DOCKER_NETWORK_OPTIONS=.*$|DOCKER_NETWORK_OPTIONS='--bip=$DOCKER_BRIDGE'|" /etc/sysconfig/docker-network
echo "INSECURE_REGISTRY='--insecure-registry=172.30.0.0/16'" >> /etc/sysconfig/docker
systemctl enable docker

mkdir -p /tmp/go
curl -L $GOLANG_TAR > /tmp/go/go.tar.gz
tar xf /tmp/go/go.tar.gz -C /usr/local
mkdir /go && chown vagrant:vagrant /go && chmod 777 /go

# Include insecure key for base box
curl -L "https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub" \
  >> /home/vagrant/.ssh/authorized_keys
