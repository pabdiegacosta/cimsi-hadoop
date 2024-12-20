# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "generic/ubuntu1804"
NODE_COUNT = 3
USER = "hadoop"
PASSWORD = "cimsi"

Vagrant.configure("2") do |config|
  ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
  
  config.vm.define "master" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "master"     
    subconfig.vm.network "private_network", ip: "192.168.56.20"
    subconfig.vm.provision "shell", inline: <<-SHELL
      useradd -m -s /bin/bash #{USER}
      echo '#{USER}:#{PASSWORD}' | chpasswd
      usermod -aG sudo #{USER}
      # Ensure the .ssh directory exists
      mkdir -p /home/#{USER}/.ssh
      # Add the public key to the authorized_keys file
      echo #{ssh_pub_key} >> /home/#{USER}/.ssh/authorized_keys
      chown -R #{USER}:#{USER} /home/#{USER}/.ssh
    SHELL
  end
  
  (1..NODE_COUNT).each do |i|
    config.vm.define "worker#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname = "worker#{i}"
      subconfig.vm.network "private_network", ip: "192.168.56.#{20+i}"
      subconfig.vm.provision "shell", inline: <<-SHELL
        useradd -m -s /bin/bash #{USER}
        echo '#{USER}:#{PASSWORD}' | chpasswd
        usermod -aG sudo #{USER}
        # Ensure the .ssh directory exists
        mkdir -p /home/#{USER}/.ssh
        # Add the public key to the authorized_keys file
        echo #{ssh_pub_key} >> /home/#{USER}/.ssh/authorized_keys
        chown -R #{USER}:#{USER} /home/#{USER}/.ssh
      SHELL
    end
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "5120"
    vb.cpus = 2
  end
end
