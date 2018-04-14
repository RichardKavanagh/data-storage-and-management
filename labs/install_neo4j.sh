#!/bin/bash

# Commands used
# echo, wget, tar, ln, cd

echo 'Starting Neo4J installation ...'

echo 'Configuring hadoop user & groups ...'
./add_user.sh

echo 'Installing dependencies ...'
dpkg --configure -a
apt-get update
apt-get install openjdk-8-jre openjdk-8-jdk -y

echo 'Downloading neo4j ...'
wget http://dist.neo4j.org/neo4j-community-3.3.3-unix.tar.gz
tar xzf neo4j-community-3.3.3-unix.tar.gz
ln -s neo4j-community-3.3.3 neo4j

echo 'Running neo4j ...'
cd neo4j
./bin/neo4j start

echo 'Finished Neo4J installation ...'
