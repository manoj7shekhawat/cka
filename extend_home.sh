#!/bin/bash

echo This script is for extending LVM size for user home directory
echo on Azure Red Hat Enterprise Linux 8.5

echo First attach a disk to vm

echo sudo fdisk /dev/sdc

echo change type to Linux LVM

echo sudo vgextend rootvg /dev/sdc1

echo lvextend -r -L +20G /dev/rootvg/homelv 
