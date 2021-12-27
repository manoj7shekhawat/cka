#!/bin/bash

echo This script is for extending LVM size for user home directory
echo on Azure Red Hat Enterprise Linux 8.5

echo First attach a disk to vm

echo fdisk /dev/device

echo change type to Linux LVM

vgextend rootvg /dev/sdc2

lvextend -r -L +10G /dev/rootvg/homelv 
