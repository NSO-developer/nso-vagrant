# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-18.04"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. 
  config.vm.network "forwarded_port", guest: 80, host: 8089
  config.vm.network "forwarded_port", guest: 443, host: 8449
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
     vb.memory = "8096"
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
  config.vm.provision :shell, :inline => "rm -rf $HOME/nso-install/packages/neds/ && mkdir -p $HOME/nso-install/packages/neds/", :privileged => false
  config.vm.provision :shell, :inline => "mv $HOME/cisco-* $HOME/nso-install/packages/neds/", :privileged => false
  config.vm.provision :shell, :inline => "rm cisco_x509_verify_release.py && rm README.signature && rm tailf.cer && rm n*5.*", :privileged => false
  config.vm.provision :shell, :inline => "source $HOME/nso-install/ncsrc; $HOME/nso-install/bin/ncs-setup --dest $HOME/nso-run", :privileged => false
  config.vm.provision :shell, :inline => "ln -s $HOME/nso-install/packages/neds/cisco-* $HOME/nso-run/packages/", :privileged => false
  config.vm.provision :shell, :inline => "echo Turning on NSO, this may take a bit.", :privileged => false
  config.vm.provision :shell, :inline => "source $HOME/nso-install/ncsrc; cd $HOME/nso-run/; ncs --with-package-reload-force", :privileged => false
  config.vm.provision :shell, :inline => "echo All done! Login with vagrant ssh, and then use ncs_cli -C -u admin or the bash alias kickoffnso to login to the NSO cli"
end
