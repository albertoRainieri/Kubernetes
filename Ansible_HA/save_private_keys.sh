#!/bin/bash
# DEFINE YOUR SETTINGS
loadbalancer1=192.168.61.51
loadbalancer2=192.168.61.52
kmaster1=192.168.61.101
kmaster2=192.168.61.102
kmaster3=192.168.61.103
kworker1=192.168.61.201
path=$HOME/Kubernetes/vagrant_init/Ansible_HA
root_path=/home/alberto

ssh-keygen -f "$root_path/.ssh/known_hosts" -R $loadbalancer1
ssh-keygen -f "$root_path/.ssh/known_hosts" -R $loadbalancer2
ssh-keygen -f "$root_path/.ssh/known_hosts" -R $kmaster1
ssh-keygen -f "$root_path/.ssh/known_hosts" -R $kmaster2
ssh-keygen -f "$root_path/.ssh/known_hosts" -R $kmaster3
ssh-keygen -f "$root_path/.ssh/known_hosts" -R $kworker1

eval `ssh-agent -s`
ssh-add "$path"/.vagrant/machines/loadbalancer1/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$loadbalancer1" 'echo hello loadbalancer1'
sleep 1
ssh-add "$path"/.vagrant/machines/loadbalancer2/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$loadbalancer2" 'echo hello loadbalancer2'
sleep 1
ssh-add "$path"/.vagrant/machines/kmaster1/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$kmaster1" 'echo hello kmaster1'
sleep 1
ssh-add "$path"/.vagrant/machines/kmaster2/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$kmaster2" 'echo hello kmaster2'
sleep 1
ssh-add "$path"/.vagrant/machines/kmaster3/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$kmaster3" 'echo hello kmaster3'
sleep 1
ssh-add "$path"/.vagrant/machines/kworker1/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$kworker1" 'echo hello kworker1'
sleep 1

