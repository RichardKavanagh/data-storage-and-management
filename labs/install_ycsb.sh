#!/bin/bash

# Commands used
# echo, if, getent, else, fi, useradd, exec, cd, echo, curl, tar

echo 'Starting YCSB installation ...'
if [ getent passwd hduser > /dev/null 2>&1 ]
then
    echo "Hduser already exists, skipping ..."
else
	echo 'Adding new user ...'
	USER=hduser
	PASS=password
	HOME_NEW=/home/hduser
	useradd -p $(openssl passwd -1 $PASS) -m $USER
	adduser hduser sudo
fi

echo 'Logging in as hduser ...'
HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof
cd $HOME_NEW

echo 'Downloading YCSB ...'
wget https://github.com/brianfrankcooper/YCSB/releases/download/0.11.0/ycsb-0.11.0.tar.gz
tar xzf ycsb-0.11.0.tar.gz

echo 'Finished YCSB installation ...'
