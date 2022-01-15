#!/bin/bash

# Create AZ resources
# $0 ResourceGroupName
# $0 Number of nodes
 
if [ $# != 2 ]
then
	echo Usage\; $0 \<ResourceGroupName\/No of nodes\> adminPassword
else
	if [[ ! $1 =~ ^[0-9]$ ]]
	then
		echo Creating ResourceGroup\: $1 and 3 control-plane-X nodes

		echo Step 1\: Logging in
		az login

		echo Step 2\: Creating Resource Group
		az group create --name $1 --location "Germany West Central"

		for (( c=1; c<=3; c++ ))
		do
		echo Step 3\: Creating control-plane-$c VM
az deployment group create \
--resource-group $1 \
--template-file template.json \
--parameters \@parameters.json \
--parameters adminPassword=$2 \
--parameters virtualNetworkName=$1-vnet \
--parameters networkInterfaceName=control-plane-1658$c \
--parameters virtualMachineComputerName=control-plane-$c \
--parameters virtualMachineName=control-plane-$c
		done

		echo Step 4\: Listing IP address
		az vm list-ip-addresses -g $1

	else
		echo Creating $1 workers
		for (( c=1; c<=$1; c++ ))
		do
			echo Creating node$c VM
az deployment group create \
--resource-group cka \
--template-file template.json \
--parameters \@parameters.json \
--parameters adminPassword=$2 \
--parameters virtualMachineRG=cka \ 
--parameters networkInterfaceName=worker173$c \
--parameters virtualMachineComputerName=worker$c \
--parameters virtualMachineName=worker$c 
		done

		echo Listing IP addresses
		az vm list-ip-addresses -g cka
	fi
fi
