# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_IP="172.31.88.100"
HOSTNAME = "#{VM_IP}.xip.io"

$setup_script = <<EOF
#These RPMS are needed for ansible to work on Fedora using the python2 interpreter
dnf install -y python2 python2-dnf libselinux-python
EOF


Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |vb, override|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    override.vm.box = "fedora25-0.1.0-virtualbox.box"
    override.vm.box_url = "https://s3.amazonaws.com/fusor/vagrant/fedora/25/virtualbox/fedora25-0.1.0-virtualbox.box"
  end

  config.vm.provider :libvirt do |libvirt, override|
    libvirt.driver = "kvm"
    libvirt.memory = 4096
    libvirt.cpus = 2
    override.vm.synced_folder ".", "/shared", :type => "nfs", :nfs_udp => false
  end

  config.vm.hostname = HOSTNAME
  config.vm.network :private_network, ip: VM_IP
  config.vm.provision :shell, :inline => $setup_script

  config.vm.provision "ansible" do |ansible|
    ansible.extra_vars = {
      ec2_install: false,
      use_ssl: false,
      setup_docker_storage: false,
      modify_docker_network: false,
      target_user: "vagrant",
      openshift_hostname: VM_IP,
      openshift_routing_suffix: HOSTNAME
    }
    ansible.playbook = "ansible/vagrant_devel_env.yml"
  end
end
