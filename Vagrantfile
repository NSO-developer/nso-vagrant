# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-18.04"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. 
  config.vm.network "forwarded_port", guest: 80, host: 8089
  config.vm.network "forwarded_port", guest: 443, host: 8449
  config.vm.network "forwarded_port", guest: 4000, host: 4009
  config.vm.network "forwarded_port", guest: 5000, host: 5003
  config.vm.network "forwarded_port", guest: 8080, host: 8009

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.56.200", :adapter => 2

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "~/vagrant-data", "/vagrant-data", create: true
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
     # vb.gui = true
     vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "4096"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Run Ansible from the Vagrant VM
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "build-vm.yml"
    # ansible.verbose = "v"
  end

  config.ssh.forward_agent    = true
  config.ssh.insert_key       = true
  # meant for passwordless login from unix / mac
  # config.ssh.private_key_path =  ["~/.vagrant.d/insecure_private_key","~/.ssh/id_rsa"]
  # config.vm.provision :shell, privileged: false do |s|
  #   ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
  #   s.inline = <<-SHELL
  #     echo #{ssh_pub_key} >> /home/$USER/.ssh/authorized_keys
  #     # uncomment if .ssh does not exist
  #     # sudo mkdir /home/vagrant/.ssh
  #     sudo bash -c "echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys"
  #   SHELL
  # end
  config.vm.provision :shell, :inline => "source $HOME/nso-install/ncsrc; $HOME/nso-install/bin/ncs-setup --dest $HOME/nso-run", :privileged => false
  # if installing NSO version 5 and above (names changed for install ned packages)
  config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/cisco-nx-cli-3.0 $HOME/nso-run/packages/cisco-nx > /dev/null 2>&1", :privileged => false
  config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/cisco-ios-cli-3.8 $HOME/nso-run/packages/cisco-ios > /dev/null 2>&1", :privileged => false
  config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/cisco-iosxr-cli-3.5 $HOME/nso-run/packages/cisco-iosxr > /dev/null 2>&1", :privileged => false
  config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/a10-acos-cli-3.0 $HOME/nso-run/packages/a10-acos > /dev/null 2>&1", :privileged => false
  config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/dell-ftos-cli-3.0 $HOME/nso-run/packages/dell-ftos > /dev/null 2>&1", :privileged => false
  config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/juniper-junos-nc-3.0 $HOME/nso-run/packages/juniper-junos > /dev/null 2>&1", :privileged => false
  # if installing NSO version 4 and uncomment these and comment the lines above
  # config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/cisco-nx $HOME/nso-run/packages/cisco-nx > /dev/null 2>&1", :privileged => false
  # config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/cisco-ios $HOME/nso-run/packages/cisco-ios > /dev/null 2>&1", :privileged => false
  # config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/cisco-iosxr $HOME/nso-run/packages/cisco-iosxr > /dev/null 2>&1", :privileged => false
  # config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/a10-acos $HOME/nso-run/packages/a10-acos > /dev/null 2>&1", :privileged => false
  # config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/dell-ftos $HOME/nso-run/packages/dell-ftos > /dev/null 2>&1", :privileged => false
  # config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/juniper-junos $HOME/nso-run/packages/juniper-junos > /dev/null 2>&1", :privileged => false

  # Start NSO daemon (which needs to be started each time VM shuts down) 
  config.vm.provision :shell, :inline => "source $HOME/nso-install/ncsrc; cd $HOME/nso-run/; ncs --with-package-reload-force", :privileged => false
  # Create A few Netsims to start with
  config.vm.provision :shell, :inline => "source $HOME/nso-install/ncsrc; cd $HOME/nso-run/; ncs-netsim create-network $HOME/nso-run/packages/cisco-ios 3 netsim-ios-", :privileged => false

end
