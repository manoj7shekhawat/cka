#!/bin/bash

if [ $# != 1 ]
then
	echo Usage\: $0 \<ResourceGroupName\>
else
	echo Deleting Az resources

	echo Logging In

	az login

	az account show

	az group delete -n $1

	echo Done please verify on AZ Portal :-\)  
fi
