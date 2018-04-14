#!/bin/bash

# Commands used echo, addgroup, useradd, adduser

HOME_NEW=/home/hduser

function main {

	if getent passwd hduser > /dev/null 2>&1; then
	    echo "Hduser already exists, skipping ..."
	else
		echo 'Adding new group ...'
		addgroup hadoop
		echo 'Adding new user ...'
		USER=hduser
		PASS=password
		HOME_NEW=/home/hduser
		useradd -p $(openssl passwd -1 $PASS) -m $USER
		adduser hduser sudo
	fi
}

main
