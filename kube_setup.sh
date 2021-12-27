#!/bin/bash

# verified on RED HAT 8.5

##########
echo ########################################
echo WARNING
echo ########################################

echo This script is written for Azure Red Hat 8.5 VM

echo Script requires the machine where you run it to have 8GB of RAM or more

echo User must have sudo access

echo press Enter to continue
read

echo STEP 1: Check for RHEL updates

sudo dnf -y update

echo STEP 2: Install KVM:

sudo dnf install -y @virt

echo STEP 3: Install virtual machine management tools

sudo dnf install -y libvirt-devel virt-top libguestfs-tools

echo STEP 4: Enable and start KVM service

sudo systemctl enable --now libvirtd

echo STEP 5: Install graphical virtual machine manager

sudo dnf install -y virt-manager

echo STEP 6: Check that KVM is running

sudo systemctl status libvirtd

echo STEP 7:  Adding user should to the libvirt group:

sudo usermod -aG libvirt $(whoami)

newgrp libvirt

echo STEP 8: Editing libvirtd.conf

echo unix_sock_group = “libvirt” | sudo tee -a /etc/libvirt/libvirtd.conf

echo unix_sock_rw_perms = “0770” | sudo tee -a /etc/libvirt/libvirtd.conf

echo STEP 9: Restart the KVM service

sudo systemctl restart libvirtd.service

echho STEP 10: Downloading the latest minikube package

sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm

echo STEP 11: Installng minikube

sudo rpm -Uvh minikube-latest.x86_64.rpm

echo STEP 12: Checking minikube version

minikube version

echo STEP 13: Download kubectl (check path to latest version on dl.k8s.io):

curl -LO https://dl.k8s.io/release/v1.22.0/bin/linux/amd64/kubectl

echo STEP 14: Installing kubectl

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo STEP 15: Check kubectl version to ensure successful install

kubectl version --client

echo STEP 16: Typing “kubectl” gives a full list of commands

kubectl

echo STEP 17: Typing “minikube” gives a full list of commends

minikube

echo STEP 18:  Creating a local minikube Kubernetes cluster

minikube start --vm-driver=kvm2

echo STEP 19: Now running some kubectl commands to inspect the Kubernetes cluster

kubectl get nodes

minikube status

kubectl get pod

kubectl get services

echo I'm done :)
