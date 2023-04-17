# <Ansible-HA-K8s>

# Description

Deploy a K8S Cluster with Ansible. In particular the cluster is made of these nodes:
- 1 Master Nodes
- 2 Worker Node

For testing purposes, You can create a local enviroment in your hostmachine by creating these nodes with Vagrant and VirtualBox. See Installation paragraph for further informations.

# Table of Contents

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Installation](#installation)

# Requirements
These are the requirements to install this simple K8S Cluster.

1) Install Virtualbox, Vagrant and Ansible

# Configuration
### Configure Vagrantfile
Configure ~/Vagrantfile by deciding how many CPUs, RAM you want to provide to your VMs. Also select carefully the IP addresses that will be assigned to your VMs.

### Configure Vars
Configure ~/playbook/vars.yaml. In this configuration choose the ip address and hostnames (equal to those in Vagrantfile) and paths of your hostmachine and VMs

### Configure Hosts
Configure ~/hosts.yaml. This is a symbolic link to /etc/ansible/hosts. It defines hosts, ip addresses, and users

### Start SSH connections with your VMs
In order to let Ansible know how to ssh into your VMs, you should ssh into them in your terminal first.

The template that you find in ~/save_private_keys.sh helps you to do this step. Configure your settings (ip addresses, paths) inside the shell script, finally copy and paste the content on your terminal. Ansible is now able to ssh into them.

# Installation
Once Vagrant, Virtualbox and Ansible are installed you can start your HA K8S cluster.

### Provision your VMs with Vagrant (only for local environments)
```
vagrant up master worker1 worker2
```

### Configure Loadbalancers, master and worker nodes with Ansible
#### Option 1. COnfigure one-by-one
```
ansible-playbook playbook/install-k8s.yaml
ansible-playbook playbook/initialize-cluster.yaml
ansible-playbook playbook/join-cluster.yaml
```

#### Option 2. Configure all together
```
ansible-playbook create-k8s-cluster.yaml
```

Installation and configuration completed.