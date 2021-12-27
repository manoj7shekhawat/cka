#!/bin/bash

sudo yum group install "Server with GUI" -y

sudo yum install tigervnc tigervnc-server -y

sudo firewall-cmd --add-port=5901/tcp

sudo firewall-cmd --add-port=5901/tcp --permanent

sudo firewall-cmd --reload

echo Make sure to open 5901 in Ingress/Inbound rules

echo I am done 
