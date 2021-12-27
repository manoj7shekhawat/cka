#!/bin/bash

# verified on RED HAT 8.5

##########
echo ########################################
echo WARNING
echo ########################################

echo This script is written for Azure Red Hat 8.5 VM

echo Make sure we have 10 GB free in users home directory

echo 8GB of RAM or more is recommended

echo User must have sudo access

echo press Enter to continue
read

egrep '^flags.*(vmx|svm)' /proc/cpuinfo || (echo enable CPU virtualization support and try again && exit 9)

echo Step 1: Update RHEL packages

sudo dnf -y update

echo Step 2: Installing KVM

sudo dnf install -y @virt

echo Step 3: Installing virtual machine management tools

sudo dnf install -y libvirt-devel virt-top libguestfs-tools

echo Step 4: Enable and starting KVM service

sudo systemctl enable --now libvirtd

echo Step 5: Install graphical virtual machine manager

sudo dnf install -y virt-manager

echo Step 6: Check that KVM is running

sudo systemctl is-active --quiet libvirtd && echo libvirtd Service is running

echo Step 7:  Adding user should to the libvirt group:

sudo usermod -aG libvirt `id -un`

# newgrp libvirt

echo Step 8: Editing libvirtd.conf

echo unix_sock_group = “libvirt” | sudo tee -a /etc/libvirt/libvirtd.conf

echo unix_sock_rw_perms = “0770” | sudo tee -a /etc/libvirt/libvirtd.conf

echo Step 9: Restart the KVM service

sudo systemctl restart libvirtd.service
sudo systemctl is-active --quiet libvirtd && echo libvirtd Service is running

echho Step 10: Downloading the latest minikube package

sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm

echo Step 11: Installng minikube

sudo rpm -Uvh minikube-latest.x86_64.rpm

if rpm -q minikube-latest > /dev/null; then echo "Package minikube-latest is installed."; fi

echo Step 12: Checking minikube version

minikube version

echo Step 13: Download kubectl \(check path to latest version on dl.k8s.io\):

curl -LO https://dl.k8s.io/release/v1.22.0/bin/linux/amd64/kubectl

echo Step 14: Installing kubectl

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo Step 15: Check kubectl version to ensure successful install

kubectl version --client

echo Step 16: Typing “kubectl” gives a full list of commands

kubectl

echo Step 17: Typing “minikube” gives a full list of commends

minikube

echo Step 18:  Creating a local minikube Kubernetes cluster

minikube start --memory 4096 --vm-driver=kvm2

echo Step 19: Now running some kubectl commands to inspect the Kubernetes cluster

kubectl get nodes

minikube status

kubectl get pod

kubectl get services

echo I'm done :)
