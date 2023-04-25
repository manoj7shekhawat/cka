#!/bin/bash

# Date: 06-Jan-2022
# Author: Manoj Shekhawat
# This script is written for RHEL 8.5 OR CentOS Linux 8 VM on Azure Cloud
# This is first part in setting up Kubernetes cluster
# After this please run: setup-kubetools.sh
# Last modified: 25-Apr-2023

# For Kubernetes v1.26.x
VERSION=1.26

MYOS=$(hostnamectl | awk -F': ' '/Operating/ { print $2}')

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 3
fi

if [[ $MYOS =~ ^Red[[:space:]]Hat[[:space:]]Enterprise[[:space:]]Linux[[:space:]]8* ]] || [[ $MYOS =~ ^CentOS[[:space:]]Linux[[:space:]]8$ ]]
then
	echo Working on: $MYOS

	echo Step 1: Disabling swap space

	swapoff -a

  echo Step 2: Removing old packages

  dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine podman runc

	echo Step 3: Installing vim yum-utils iproute-tc

	dnf install -y vim yum-utils iproute-tc

	echo Step 4: Adding CRI-O repository
	curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo
	curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/CentOS_8/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo

	echo Step 5: Installing cri-o
	dnf install -y cri-o

	echo Step 6: Reloading daemon
	systemctl daemon-reload

	echo Step 7: Enabling crio
	systemctl enable --now crio

	echo Step 8: Restarting crio
  systemctl restart crio

	echo Step 9: Disabling Firewalld
	systemctl disable --now firewalld

	echo I am done :-\)
else
	echo "Script is for Red Hat Linux 8+ or CentOS Linux 8 only"
fi
