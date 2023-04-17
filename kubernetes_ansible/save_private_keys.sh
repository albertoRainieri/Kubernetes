#!/bin/bash
# DEFINE YOUR SETTINGS
master=192.168.59.100
worker1=192.168.59.111
worker2=192.168.59.112
path=$HOME/Kubernetes/vagrant_init/kubernetes_ansible
root_path=/home/alberto

ssh-keygen -f "$root_path/.ssh/known_hosts" -R $master
ssh-keygen -f "$root_path/.ssh/known_hosts" -R $worker1
ssh-keygen -f "$root_path/.ssh/known_hosts" -R $worker2

eval `ssh-agent -s`
ssh-add "$path"/.vagrant/machines/master/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$master" 'echo hello master'
sleep 1
ssh-add "$path"/.vagrant/machines/worker1/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$worker1" 'echo hello worker1'
sleep 1
ssh-add "$path"/.vagrant/machines/worker2/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$worker2" 'echo hello worker2'
sleep 1

