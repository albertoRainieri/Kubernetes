This guide will help you to deploy a kubernetes cluster locally.

# download vagrant
First of all, download Vagrant. Vagrant will help you manage the cluster creation through Vagrantfile
Visit https://www.vagrantup.com/downloads, and follow the download instructions.

# download VirtualBox
Download VirtualBox on https://www.virtualbox.org/wiki/Downloads


# kubernetes_init
Create Kubernetes Cluster with Vagrant

# Create Cluster
vagrant up

# Check your nodes
vagrant status

# Access one of your nodes
vagrant ssh <node_name>

# destroy VM
vagrant destroy <node_name>
