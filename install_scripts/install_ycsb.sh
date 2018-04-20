#!/bin/bash

# Commands used
# echo, if, getent, else, fi, useradd, exec, cd, echo, curl, tar

echo 'Starting YCSB installation ...'

echo 'Configuring hadoop user & groups ...'
../helper_scripts/add_user.sh

echo 'Logging in as hduser ...'
HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof
cd $HOME_NEW

echo 'Downloading YCSB ...'
wget https://github.com/brianfrankcooper/YCSB/releases/download/0.11.0/ycsb-0.11.0.tar.gz
tar xzf ycsb-0.11.0.tar.gz

echo 'Finished YCSB installation ...'
