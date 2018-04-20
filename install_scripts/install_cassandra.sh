#!/bin/bash

# Commands used
# echo, dpkg, apt-get, install, wget, tar, ln, mkdir, chown

echo 'Starting Cassandra installation ...'

echo 'Installing dependencies ...'
dpkg --configure -a
apt-get update
apt-get install openjdk-8-jre openjdk-8-jdk -y

echo 'Configuring hadoop user & groups ...'
./helper_scripts/add_user.sh

echo 'Creating cassandra folders in /var/lib & /var/log'
mkdir /var/lib/cassandra
mkdir /var/log/cassandra
chown -R hduser:hadoop /var/lib/cassandra
chown -R hduser:hadoop /var/log/cassandra

HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof

echo 'Downloading cassandra from apache.org ...'
cd $HOME_NEW
wget http://www-eu.apache.org/dist/cassandra/3.0.16/apache-cassandra-3.0.16-bin.tar.gz
tar -zxf apache-cassandra-3.0.16-bin.tar.gz
ln -s apache-cassandra-3.0.16 cassandra

echo 'Finished Cassandra installation ...'
