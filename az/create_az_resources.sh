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
		echo Creating ResourceGroup\: $1 and control-plane node

		echo Step 1\: Logging in
		az login

		echo Step 2\: Creating Resource Group
		az group create --name $1 --location "Germany West Central"

		echo Step 3\: Creating control-plane VM
		az deployment group create --resource-group $1 \
--template-file template.json --parameters \@parameters.json \
--parameters adminPassword=$2 \
--parameters virtualNetworkName=$1-vnet \
--parameters virtualMachineRG=$1 

		echo Step 4\: Listing IP address
		az vm list-ip-addresses -g $1 -n control-plane

	else
		echo Creating $1 nodes
		for (( c=1; c<=$1; c++ ))
		do
			echo Creating node$c VM
			az deployment group create \
--resource-group cka \
--template-file template-node.json \
--parameters \@parameters-node.json \
--parameters adminPassword=$2 \
--parameters networkInterfaceName=node173$c \
--parameters virtualMachineComputerName=node$c \
--parameters virtualMachineName=node$c 
		done

		echo Listing IP addresses
		az vm list-ip-addresses -g cka
	fi
fi
