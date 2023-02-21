# <Ansible-HA-K8s>

# Description

Deploy a HA K8S Cluster with Ansible. In particular the cluster is made of these nodes:
- 2 LoadBalancers (HA Proxy)
- 3 Master Nodes
- 1 Worker Node

For testing purposes, You can create a local enviroment in your hostmachine by creating these nodes with Vagrant and VirtualBox. See Installation paragraph for further informations.

# Table of Contents

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Installation](#installation)

# Requirements
These are the requirements to install this HA K8S Cluster.

1) Install Virtualbox, Vagrant and Ansible
2) Host machine must have a minimum of 16GB of RAM e 12CPUs (if you want to test it on your computer)

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
vagrant up loadbalancer1 loadbalancer2 kmaster1 kmaster2 kmaster3 kworker1

### Configure Loadbalancers, master and worker nodes with Ansible
### OPTION 1. COnfigure one-by-one
ansible-playbook playbook/01-init-loadbalancers.yaml
ansible-playbook playbook/02-install-k8s.yaml
ansible-playbook playbook/03-initialize-cluster.yaml
ansible-playbook playbook/04-join-master.yaml
ansible-playbook playbook/05-join-worker.yaml

### OPTION 2. Configure all together
ansible-playbook playbook/create-ha-k8s-cluster.yaml


Installation and configuration completed.