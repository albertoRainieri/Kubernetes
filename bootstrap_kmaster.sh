#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.59.100 --pod-network-cidr=192.168.60.0/24 >> /root/kubeinit.log 2>/dev/null

echo "[TASK 3] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

echo "[TASK 5] Install docker and docker-compose. Useful for pulling private docker images."
apt install -y docker.io docker-compose apache2-utils
apt-get -y install net-tools
apt install nfs-kernel-server

echo "[TASK 6] Give vagrant User sudo priviliges for kubectl and docker"
sudo su vagrant
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo usermod -aG docker $USER
sudo chown vagrant:vagrant /var/run/docker.sock
