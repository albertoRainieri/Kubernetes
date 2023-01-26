#!/bin/bash

#!/bin/bash

echo "[TASK 1] Join node to Kubernetes Cluster"
apt install -qq -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster.example.com:/joincluster.sh /joincluster.sh
bash /joincluster.sh


echo "[TASK 2] Install docker and login to remote repository"
apt update
apt install -y docker.io
apt-get -y install net-tools
apt install -y nfs-common

sudo su vagrant
sudo usermod -aG docker $USER
sudo chown vagrant:vagrant /var/run/docker.sock
