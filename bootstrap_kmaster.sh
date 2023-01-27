#!/bin/bash

#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull #>/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.59.100 --pod-network-cidr=192.168.60.0/24 #>> /root/kubeinit.log #2>/dev/null

echo "[TASK 3] Deploy Calico network"

curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh #2>/dev/null


echo "[TASK 5] Install docker and docker-compose. Useful for pulling private docker images."
apt-get -y install net-tools
apt install nfs-kernel-server

echo "[TASK 6] Install DOcker"
# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
apt-get update
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key:    
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
Use the following command to set up the repository:

#Use the following command to set up the repository:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Use the following command to set up the repository:
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin



# sudo su vagrant
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# sudo usermod -aG docker $USER
# sudo chown vagrant:vagrant /var/run/docker.sock
