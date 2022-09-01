## Create Kubernetes Cluster with Vagrant
This guide will help you to deploy a kubernetes cluster locally.

# Download vagrant
First of all, download Vagrant. Vagrant will help you manage the cluster creation through Vagrantfile
Visit https://www.vagrantup.com/downloads, and follow the download instructions.

# Download VirtualBox
Download VirtualBox on https://www.virtualbox.org/wiki/Downloads

# Create Cluster
vagrant up

# Check your nodes
vagrant status

# Access one of your nodes
vagrant ssh <node_name>

# destroy VM
vagrant destroy <node_name>
