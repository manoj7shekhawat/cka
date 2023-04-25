#!/bin/bash

# Date: 06-Jan-2022
# Author: Manoj Shekhawat
# This script is written for RHEL 8.5 OR CentOS Linux 8 VM on Azure Cloud
# This is first part in setting up Kubernetes cluster
# After this please run: setup-kubetools.sh
# Last modified: 25-Apr-2023


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

	echo Step 3: Installing vim yum-utils device-mapper-persistent-data lvm2

	dnf install -y vim yum-utils device-mapper-persistent-data lvm2

	echo Step 4: Adding Docker repository
	dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

	echo Step 5: Installing Docker-CE
	dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	echo Step 6: Creating required directories
	[ ! -d /etc/docker ] && mkdir /etc/docker

	mkdir -p /etc/systemd/system/docker.service.d

	echo Step 7: Creating daemon.json under /etc/docker

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

	echo Step 8: Reloading daemon
	systemctl daemon-reload

	echo Step 9: Restarting Docker
	systemctl restart docker

	echo Step 10: Enabling Docker
	systemctl enable docker

	echo Step 11: Disabling Firewalld
	systemctl disable --now firewalld

	echo I am done :-\)
else
	echo "Script is for Red Hat Linux 8+ or CentOS Linux 8 only"
fi
