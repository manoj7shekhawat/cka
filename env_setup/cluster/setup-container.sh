#!/bin/bash

# Date: 06-Jan-2022
# Author: Manoj Shekhawat
# This script is written for RHEL 8.5 VM on Azure Cloud
# This is first part in setting up Kubernetes cluster
# After this please run: setup-kubetools.sh


MYOS=$(hostnamectl | awk -F': ' '/Operating/ { print $2}')

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 3
fi

if [[ $MYOS =~ ^Red[[:space:]]Hat[[:space:]]Enterprise[[:space:]]Linux[[:space:]]8* ]]
then
	echo Working on: $MYOS
	
	echo Step 1: Installing vim yum-utils device-mapper-persistent-data lvm2

	dnf install -y vim yum-utils device-mapper-persistent-data lvm2

	echo Step 2: Adding Docker repository
	dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

	echo Step 3: Installing Docker-CE
	dnf install -y docker-ce

	echo Step 4: Creating required directories
	[ ! -d /etc/docker ] && mkdir /etc/docker

	mkdir -p /etc/systemd/system/docker.service.d

	echo Step 5: Creating daemon.json under /etc/docker

	cat > /etc/docker/daemon.json <<- EOF
	{
	  "exec-opts": ["native.cgroupdriver=systemd"],
	  "log-driver": "json-file",
	  "log-opts": {
	    "max-size": "100m"
	  },
	  "storage-driver": "overlay2",
	  "storage-opts": [
	    "overlay2.override_kernel_check=true"
	  ]
	}
	EOF

	echo Step 6: Reloading daemon
	systemctl daemon-reload

	echo Step 7: Restarting Docker
	systemctl restart docker

	echo Step 8: Enabling Docker
	systemctl enable docker

	echo Step 9: Disabling Firewalld
	systemctl disable --now firewalld

	echo I am done :-\)
else
	echo "Script is for Red Hat Linux"
fi
