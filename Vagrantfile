
# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "generic/ubuntu1804"
NODE_COUNT = 3

Vagrant.configure("2") do |config|
  config.vm.define "master" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "master"     
    subconfig.vm.network "private_network", ip: "192.168.56.20"
    subconfig.vm.provision "shell", inline: <<-SHELL
      useradd -m -s /bin/bash master
      echo 'master:cimsi' | chpasswd
      usermod -aG sudo master
    SHELL
    # subconfig.vm.provision "shell", inline: <<-SHELL
    #   # Variables
    #   USERNAME="master"
    #   PASSWORD="cimsi"

    #   # Create the user with a home directory and set the shell
    #   useradd -m -s /bin/bash $USERNAME
      
    #   # Set the password for the user
    #   echo "$USERNAME:$PASSWORD" | chpasswd
      
    #   # Add the user to the sudo group
    #   usermod -aG sudo $USERNAME

    #   # Ensure the .ssh directory exists
    #   mkdir -p /home/$USERNAME/.ssh

    #   # Add the public key to the authorized_keys file
    #   ssh_pub_key=$(cat $HOME/.ssh/id_ed25519.pub)
    #   echo $ssh_pub_key >> /home/$USERNAME/.ssh/authorized_keys
    #  SHELL
 
  end
  
  (1..NODE_COUNT).each do |i|
    config.vm.define "worker#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname = "worker#{i}"
      subconfig.vm.network "private_network", ip: "192.168.56.#{20+i}"
      subconfig.vm.provision "shell", inline: <<-SHELL
        useradd -m -s /bin/bash worker
        echo "worker:cimsi" | chpasswd
        usermod -aG sudo worker
      SHELL
      # subconfig.vm.provision "shell", inline: <<-SHELL
      # # Variables
      #   USERNAME="master"
      #   PASSWORD="cimsi"

      #   # Create the user with a home directory and set the shell
      #   useradd -m -s /bin/bash $USERNAME
        
      #   # Set the password for the user
      #   echo "$USERNAME:$PASSWORD" | chpasswd
        
      #   # Add the user to the sudo group
      #   usermod -aG sudo $USERNAME

      #   # Ensure the .ssh directory exists
      #   mkdir -p /home/$USERNAME/.ssh

      #   # Add the public key to the authorized_keys file
      #   ssh_pub_key=$(cat $HOME/.ssh/id_ed25519.pub)
      #   echo $ssh_pub_key >> /home/$USERNAME/.ssh/authorized_keys
      # SHELL
    end
  end

   config.vm.provider "virtualbox" do |vb|

     vb.memory = "512"
   end
end

