# Vagrant NSO on Ubuntu 18 for Getting Started

[![published](https://static.production.devnetcloud.com/codeexchange/assets/images/devnet-published.svg)](https://developer.cisco.com/codeexchange/github/repo/jabelk/nso-getting-started)

## link to download NSO
https://developer.cisco.com/docs/nso/#!getting-nso/downloads

## Prereqs:
- Install Vagrant, Install Ansible / Python locally on your laptop (outside the scope of this tutorial, just google it)

#### Tested on:
- OS X 10.15.2
- Ansible version 2.7.6 (to install NSO on VM)
- Vagrant version 2.2.6
- Virtualbox Guest Additions 5.2.26 - guest version is 5.2.22
Though it should work on other systems...pretty standard stuff. 

## Steps:
1. Clone this repo: `git clone https://github.com/jabelk/nso-getting-started.git`
1. Download the Cisco NSO application **installer file** (`nso-VERSION-NUMBER.linux.x86_64.signed.bin`)
1. Download the Cisco NSO **Cisco IOS (XE) NED, Cisco IOS XR NED, Cisco NXOS NED** (`ncs-NSOVERSION-cisco-PLATFORM-NEDVERSION.signed.bin`)
1. Move the installer file **and** the three NED files from your Downloads to where you cloned this repo, in its `files` directory. (for example) `nso-vagrant/files/nso-VERSION-NUMBER.linux.x86_64.signed.bin` 
1. `vagrant up` (in the repo working directory where the VagrantFile is)
1. `vagrant ssh` and then `ncs_cli -C -u admin` to login to NSO. OR http://localhost:8009 for the NSO GUI

> note, if you restart the VM after installing (rather than just suspending), you will need to turn on the NSO application `source $HOME/nso-install/ncsrc; cd $HOME/nso-run/; ncs;`, if you get the following error `Cannot bind to internal socket 127.0.0.1:4569 : address already in use
Daemon died status=20`, then NSO is already running. 

> also note: the installation process assumes the files are in the signed.bin, not installer.bin or .tar.gz for NED. You can update the ansible tasks if this is not the case for you. 

## Getting Started

A couple of things. NSO when it is installed comes with a ton of documentation in the `nso-install/doc` directory. Check it out.

NSO comes with a bunch of examples in the `nso-install/examples.ncs` directory. Note that if you follow them, you will want to stop the NSO running in `nso-run` (using `ncs --stop` in the `nso-run` directory) since you can only have one instance of NSO running at a time and most of the examples assume you will use `ncs-setup` to set up a new instance of NSO to run the particular example. 

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

### Vagrant Specific Stuff

You should be able to access the NSO GUI over the ports exposed from the VM on your laptop. You can always verify what the port mapping is to your laptop by going `vagrant port`. NSO GUI is by default port 8080 locally within the VM, see what it is mapped to based on your available ports. 

## Shared Folder and NEDs

As part of the Vagrant set up, I added a shared folder, in my case it is called `vagrant-data`, but you can call it whatever you want. 

If you want to use other NEDs, I suggest using that shared folder to transfer them in, or update the playbook to copy them over at provision time from the files directory. Make sure to put them in the packages directory and run `make clean all` in the `package/src` folder if it was compiled for a different release of NSO than what you have installed. 

>The shared folder is also good for exporting or pulling in service packages for testing, make sure to change owners though...otherwise you might get permission issues. 

# How Can I Edit Text Files on the Local VM?

I have had good luck with using a remote ssh edit package on either Sublime or VS Code, pointed to your localhost VM ssh ports. 

Here are two examples. 

## Sublime
https://wbond.net/sublime_packages/sftp

## VS Code
https://code.visualstudio.com/docs/remote/remote-overview


## Shared Folder and NEDs

As part of the Vagrant set up, I add a shared folder, in my case it is called `vagrant-data`, but you can call it whatever you want. If you want to use updated neds, I suggest using that shared folder to transfer them in, or update the playbook to copy them over at provision time from the files directory. Make sure to put them in the packages directory and run `make clean all` in the `package/src` folder if it was compiled for a different release of NSO than what you have installed. 

The shared folder is also good for exporting or pulling in service packages for testing, make sure to change owners though...otherwise you might get permission issues. 


## NSO Versions

If you are trying to install a different version of NSO than the one this repo is designed for, double check the `build-vm.yml` file and update the `nso_version` variable:

```yaml
---
- hosts: all
  connection: paramiko
  become: yes

  vars:
    nso_install_location: "/home/{{ ansible_ssh_user }}/nso-install"
    nso_version: "UPDATE-ME-IF-NEEDED"
    # for example for nso-5.2.1.linux.x86_64.installer.bin nso_version is "5.2.1"
    user: vagrant

  tasks:
    - import_tasks: tasks/linux_packs.yml
    - import_tasks: tasks/install_nso.yml

```
