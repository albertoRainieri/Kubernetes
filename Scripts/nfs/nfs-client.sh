#!/bin/bash

source input.txt

sudo apt update
sudo apt install nfs-common

sudo mkdir -p /nfs/general
sudo mount $host_ip:/var/nfs/general /nfs/general