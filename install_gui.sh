#!/bin/bash

sudo yum group install "Server with GUI" -y

sudo yum install tigervnc tigervnc-server -y

sudo firewall-cmd --add-port=5901/tcp

sudo firewall-cmd --add-port=5901/tcp --permanent

sudo firewall-cmd --reload

sudo dnf install langpacks-en glibc-all-langpacks -y

sudo localectl set-locale LANG=en_US.utf8

# Export LANG before starting VNC
echo export LC_CTYPE=en_US.utf8
echo export LC_ALL=en_US.utf8

echo Make sure to open 5901 in Ingress/Inbound rules

echo I am done 
