# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #config.vm.box = "centos/8"
  config.vm.box = "generic/centos8"

  config.vm.hostname = "standalone-1.localdomain"
  config.vm.network :private_network, :ip => "10.20.30.40"

  config.vm.provider "libvirt" do |lv|
    lv.cpus = 4
    lv.memory = 16384
    lv.nested = true
  end

  config.vm.provision "shell", inline: <<-SHELL
    dnf remove -y epel-release
    rm -rf /etc/yum.repos.d/epel*
    dnf -y update
    dnf -y install git wget vim tmux bc
    echo "options kvm-intel nested=y" >> /etc/modprobe.d/dist.conf
    modprobe -r kvm_intel || true
    modprobe kvm_intel nested=1
    sed -i 's|SELINUX=enforcing|SELINUX=permissive|' /etc/selinux/config
    setenforce 0
  SHELL

  config.vm.provision "file", source: "standalone_parameters.yaml", destination: "$HOME/standalone_parameters.yaml"
  config.vm.provision "file", source: "deploy_standalone.sh", destination: "$HOME/deploy_standalone.sh"
  config.vm.provision "file", source: "cleanup.sh", destination: "$HOME/cleanup.sh"

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
    curl -s https://github.com/cgoncalves.keys >> ~/.ssh/authorized_keys
    curl -s -O https://cgoncalves.pt/trash/.tmux.conf
    IP=$(ip addr show dev eth1 | awk -F'[ /]*' '$2=="inet" && $5=="brd"{print $3}')
    sed -i "s/INTERFACE/eth1/g" $HOME/standalone_parameters.yaml
    sed -i "s/IP/${IP}/g" $HOME/standalone_parameters.yaml
    sed -i "s/IP/${IP}/g" $HOME/deploy_standalone.sh
    # https://bugs.centos.org/view.php?id=17133
    rm -f /etc/sysconfig/network-scripts/ifcfg-ens3
    sudo curl -s -o /etc/yum.repos.d/delorean.repo https://trunk.rdoproject.org/centos8/current-tripleo-rdo/delorean.repo
    sudo dnf -y install python3-tripleo-repos
    sudo -E tripleo-repos current-tripleo-rdo
    sudo dnf install -y python3-tripleoclient
    openstack tripleo container image prepare default --output-env-file $HOME/containers-prepare-parameters.yaml
#    curl -s -O https://images.rdoproject.org/octavia/master/amphora-x64-haproxy-centos.qcow2
  SHELL
end
