# Vagrant NSO on Ubuntu 18 for Getting Started

[![published](https://static.production.devnetcloud.com/codeexchange/assets/images/devnet-published.svg)](https://developer.cisco.com/codeexchange/github/repo/jabelk/nso-getting-started)

## link to download NSO
https://developer.cisco.com/docs/nso/#!getting-nso/downloads

## Prereqs:
- Install Vagrant, Install Ansible / Python locally on your laptop (outside the scope of this tutorial, just google it)

## Steps:
- Clone this repo: `git clone https://github.com/jabelk/nso-getting-started.git`
- Download the NSO LINUX bin installer and put it in the repo's `files` directory: `nso-getting-started/files/nso-5.1.0.1.linux.x86_64.installer.bin` (for example)
- `vagrant up` (in the repo working directory where the VagrantFile is)
- `vagrant ssh`

## Getting Started

A couple of things. NSO when it is installed comes with a ton of documentation in the `nso-install/doc` directory. Check it out.

NSO comes with a bunch of examples in the `nso-install/examples.ncs` directroy. Note that if you follow them, you will want to stop the NSO running in `nso-run` (using `ncs --stop` in the `nso-run` directory) since you can only have one instance of NSO running at a time and most of the examples assume you will use `ncs-setup` to set up a new instance of NSO to run the particular example. 

Please go through the five day training I put together (with the help of my friends at the time):
- https://learninglabs.cisco.com/modules/nso-basics (updated to be more readable)
- https://github.com/NSO-developer/nso-5-day-training (an older revision, but easier to access)

### FYI Bash Aliases

I added a few bash aliases for commonly used tasks in NSO:

```
alias kickoffnso='ncs_cli -u admin -C'
alias reloadbash='source ~/.bashrc'
alias servicepackage='ncs-make-package --service-skeleton python-and-template --augment /ncs:services '
```

## Disclaimer

The NSO NEDs that come with the free install **are limited and do not have all commands**,
see this post:
- [overview](https://community.cisco.com/t5/nso-developer-hub-discussions/what-are-the-limitations-of-the-free-nso-evaluation-download/td-p/3719787)
- [common error if trying with real device: Error: External error in the NED implementation for device mydevice: not implemented](https://community.cisco.com/t5/nso-developer-hub-discussions/error-external-error-in-the-ned-implementation-for-device/td-p/3708492) for details. 

## Vagrant Specific Stuff

You should be able to access the NSO GUI over the ports exposed from the VM on your laptop. You can always verify what the port mapping is to your laptop by going `vagrant port`. NSO GUI is by default 

Make sure to review the Vagrant file if you want to change anything. You might want to insert your ssh keys, I have the below snippet you can uncomment to do so, there are probably other ways as well. 

```
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
```

### Default NEDs and NSO Versions
If you are using the newest version (version 5.x or above), you shouldn't have to change anything on the VagrantFile. Otherwise if you use an installer bin from before NSO version 5, you will have to adapt the following lines by uncommenting the parts as indicated:
```
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

```

## Shared Folder and NEDs

As part of the Vagrant set up, I add a shared folder, in my case it is called `ntc-data`, but you can call it whatever you want. If you want to use updated neds, I suggest using that shared folder to transfer them in, or update the playbook to copy them over at provision time from the files directory. Make sure to put them in the packages directory and run `make clean all` in the `package/src` folder if it was compiled for a different release of NSO than what you have installed. 

The shared folder is also good for exporting or pulling in service packages for testing, make sure to change owners though...otherwise you might get permission issues. 

# How Can I Edit text files (like a service package) on the local VM?

I have had good luck with using a remote ssh edit package on either Sublime or VS Code. 

Here are two examples. 

## Sublime
https://wbond.net/sublime_packages/sftp

## VS Code
https://code.visualstudio.com/docs/remote/remote-overview


## Shared Folder and NEDs

As part of the Vagrant set up, I add a shared folder, in my case it is called `ntc-data`, but you can call it whatever you want. If you want to use updated neds, I suggest using that shared folder to transfer them in, or update the playbook to copy them over at provision time from the files directory. Make sure to put them in the packages directory and run `make clean all` in the `package/src` folder if it was compiled for a different release of NSO than what you have installed. 

The shared folder is also good for exporting or pulling in service packages for testing, make sure to change owners though...otherwise you might get permission issues. 

## Caveats
Tested on:
- OS X 10.14.5
- Ansible version 2.7.6 (to install NSO on VM)
- Vagrant version 2.2.3
- Virtualbox Guest Additions 5.2.26 - guest version is 5.2.22
Though it should work on other systems...pretty standard stuff. 

## Known False Positive (errors)
If you run vagrant provision more than once you will see this error, this is expected as it tries to unpack the installer in the location which already has NSO:

```
TASK [INSTALL nso] *************************************************************
fatal: [default]: FAILED! => {"changed": true, "cmd": ["sh", "/home/vagrant/nso-5.1.0.1.linux.x86_64.installer.bin", "/home/vagrant/nso-install"], "delta": "0:00:00.007180", "end": "2019-06-07 03:11:08.397758", "msg": "non-zero return code", "rc": 1, "start": "2019-06-07 03:11:08.390578", "stderr": "", "stderr_lines": [], "stdout": "ERROR ** /home/vagrant/nso-install is not empty, aborting installation", "stdout_lines": ["ERROR ** /home/vagrant/nso-install is not empty, aborting installation"]}
...ignoring

TASK [DEBUG nso INSTALL] *******************************************************
ok: [default] => {
    "nso_install": {
        "changed": true,
        "cmd": [
            "sh",
            "/home/vagrant/nso-5.1.0.1.linux.x86_64.installer.bin",
            "/home/vagrant/nso-install"
        ],
        "delta": "0:00:00.007180",
        "end": "2019-06-07 03:11:08.397758",
        "failed": true,
        "msg": "non-zero return code",
        "rc": 1,
        "start": "2019-06-07 03:11:08.390578",
        "stderr": "",
        "stderr_lines": [],
        "stdout": "ERROR ** /home/vagrant/nso-install is not empty, aborting installation",
        "stdout_lines": [
            "ERROR ** /home/vagrant/nso-install is not empty, aborting installation"
        ]
    }
}
```
