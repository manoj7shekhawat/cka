#!/bin/bash

# Date: 06-Jan-2022
# Author: Manoj Shekhawat
# This script is written for RHEL 8.5 OR CentOS Linux 8 VM on Azure Cloud
# This is second part in setting up Kubernetes cluster
# Before this please run: setup-container.sh

# For Kubernetes v1.26.3
VERSION=1.26.3

MYOS=$(hostnamectl | awk -F': ' '/Operating/ { print $2}')

if [ "$EUID" = 0 ]
  then echo "Please run $0 with sudo user"
  exit 3
fi

if [[ $MYOS =~ ^Red[[:space:]]Hat[[:space:]]Enterprise[[:space:]]Linux[[:space:]]8* ]] || [[ $MYOS =~ ^CentOS[[:space:]]Linux[[:space:]]8$ ]]
then
	echo Working on: $MYOS
	
	echo Step 1: Letting iptables see bridged traffic

	cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

   sudo modprobe overlay
   sudo modprobe br_netfilter

	cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

	sudo sysctl --system

	echo Step 2: Adding Kubernetes repository

	cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

	echo Step 3: Disabling SELinux
	sudo setenforce 0
	sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

	echo Step 4: Installing: kubelet-$VERSION kubeadm-$VERSION kubectl-$VERSION
	sudo dnf install -y kubelet-$VERSION kubeadm-$VERSION kubectl-$VERSION --disableexcludes=kubernetes

	echo Step 5: Enabling Kubelet service
	sudo systemctl enable --now kubelet

	echo Next Steps:
       	echo 1. On control-plane: As root user: kubeadm init
	echo 2. On control-plane: Configure the sudo user kube configuration
	echo 3. On control-plane: Install Weave Net using: kubectl apply -f \"https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml\"

	echo 4. On Nodes: As root user run: kubeadm join
else
	echo "Script is for Red Hat Linux 8+ OR CentOS Linux 8 only"
fi
