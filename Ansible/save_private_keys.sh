#!/bin/bash
master=192.168.59.100
worker1=192.168.59.111
worker2=192.168.59.112

ssh-keygen -f "/home/alberto/.ssh/known_hosts" -R $master
ssh-keygen -f "/home/alberto/.ssh/known_hosts" -R $worker1
ssh-keygen -f "/home/alberto/.ssh/known_hosts" -R $worker2

eval `ssh-agent -s`
ssh-add ~/Kubernetes/vagrant_ansible/.vagrant/machines/master/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$master" 'echo hello master'
sleep 1
ssh-add ~/Kubernetes/vagrant_ansible/.vagrant/machines/worker1/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$worker1" 'echo hello worker1'
sleep 1
ssh-add ~/Kubernetes/vagrant_ansible/.vagrant/machines/worker2/virtualbox/private_key
ssh -o StrictHostKeyChecking=accept-new vagrant@"$worker2" 'echo hello worker2'
sleep 1
