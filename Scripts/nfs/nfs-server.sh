#!/bin/bash

source input.txt #get $client_ip

sudo apt update
sudo apt install nfs-kernel-server
sudo mkdir /var/nfs/general -p
sudo chown nobody:nogroup /var/nfs/general

sudo bash -c "cat << EOF >> /etc/exports
/var/nfs/general    $client_ip(rw,sync,no_subtree_check)
EOF"

sudo systemctl restart nfs-kernel-server
sudo ufw allow from $client_ip to any port nfs

