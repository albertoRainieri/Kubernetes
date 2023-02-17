#!/bin/bash

#!/bin/bash

echo "[TASK 1] Join node to Kubernetes Cluster"
apt install -qq -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster.example.com:/joincluster.sh /joincluster.sh
bash /joincluster.sh


echo "[TASK 2] Install docker and login to remote repository"
apt update
apt-get -y install net-tools
apt install -y nfs-common

echo "[TASK 3] Install DOcker"
# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
apt-get update
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key:    
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#Use the following command to set up the repository:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Use the following command to set up the repository:
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

