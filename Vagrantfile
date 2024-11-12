
# TODO : Añadir a Vagrantfile completo
Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"  # Specify your base box
  
    # Basic VM settings
    config.vm.hostname = "slave"
  
    # Shell provisioning to create the user 'slave' and add it to the sudo group
    config.vm.provision "shell", inline: <<-SHELL
      # Variables
      USERNAME="slave"
      PASSWORD="cimsi"
  
      # Create the user with a home directory and set the shell
      useradd -m -s /bin/bash $USERNAME
      
      # Set the password for the user
      echo "$USERNAME:$PASSWORD" | chpasswd
      
      # Add the user to the sudo group
      usermod -aG sudo $USERNAME

      # Add the public key to the authorized_keys file
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      echo $ssh_pub_key >> /home/$USERNAME/.ssh/authorized_keys

    SHELL
  end