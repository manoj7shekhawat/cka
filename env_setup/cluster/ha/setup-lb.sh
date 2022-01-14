#!/bin/bash

#
# author: Manoj Shekhawat
# Date: 14-Jan-2022
#

# This script is to set up load balancing on all cluster nodes: Cluster-plane and Worker nodes
# Used as a practice for use in CKA courses by Sander van Vugt
# Verified on RHEL 8.5 and CentOS 8.x VMs on Azure Cloud: ONLY WITH 2 CPUs or more AND 4GB RAM or more
# Please run this AFTER running env_setup/cluster/setup-container.sh and env_setup/cluster/setup-kubetools.sh

echo ##### READ ALL OF THIS BEFORE CONTINUING ######
echo this script requires you to run setup-container.sh and setup-kubetools.sh first
echo this script is based on the NIC name eth0
echo if your networkcard has a different name, edit keepalived.conf
echo before continuing and change "interface eth0" to match your config
echo .
echo this script will create a keepalived apiserver at 192.168.200.100
echo if this IP address does not match your network configuration,
echo manually change the check_apiserver.sh file before continuing
echo press enter to continue or Ctrl-c to interrupt and apply modifications
read

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 3
fi

if [[ $MYOS =~ ^Red[[:space:]]Hat[[:space:]]Enterprise[[:space:]]Linux[[:space:]]8* ]] || [[ $MYOS =~ ^CentOS[[:space:]]Linux[[:space:]]8$ ]]
then
	echo Working on: $MYOS
# performing check on critical files
for i in keepalived.conf check_apiserver.sh haproxy.cfg
do
	if [ ! -f $i ]
	then
		echo $i should exist in the current directory && exit 2
	fi
done

echo Step 1: Installing haproxy and keepalived
yum install haproxy keepalived -y

echo Step 2: Copping files
cp check_apiserver.sh /etc/keepalived/
cp keepalived.conf /etc/keepalived/
cp haproxy.cfg /etc/haproxy/

echo Step 3: Starting keepalived and haproxy services
systemctl enable --now keepalived
systemctl enable --now haproxy

echo Step 4: Sleeping for 30 secs
sleep 30

ip a

echo Setup is now DONE, Please verify
echo You should run see the virtual IP address 192.168.200.100 in above output under eth0

echo Please run:
echo On Master control plane as root user: kubeadm init --control-plane-endpoint "192.168.200.100:8443" --upload-certs
echo On Master control plane as non root user: Create kube/config in user home directory 
echo On Master control plane as non root user: kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=\$\(kubectl version \| base64 \| tr -d \'\\n\'\)\"
echo On Slave control plane as root user: kubeadm join 
echo On Worker node as root user: kubeadm join \( Different kubeadm join Command for workers \)

echo Good Luck :-\)

else
	echo "Script is for Red Hat Linux 8+ or CentOS Linux 8 only"
fi
