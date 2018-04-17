#!/bin/bash

# Commands used
# echo, exec, cd, sed

echo 'Running ycsb benchmark test ...'

echo 'Installing dependencies ...'
dpkg --configure -a
apt-get update
apt-get install openjdk-8-jre openjdk-8-jdk

echo 'Logging in as hduser ...'
HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof
cd $HOME_NEW

cd $HOME_NEW
cd ycsb-0.11.0

if [ "$1" = "mongodb" ]; then

	echo 'Launching MongoDB Shell to delete previous benchmark results ...'
	cd $HOME_NEW
	cd mongodb/bin
	./mongo ycsb --eval 'printjson(db.dropDatabase())'

	echo 'Execute ycsb workload a (heavy with 50/50% Mix of Reads/Writes) against MongoDB ...'
	cd $HOME_NEW
	cd ycsb-0.11.0
	./bin/ycsb load mongodb -s -P workloads/workloada

elif [ "$1" = "mysql" ]; then

	echo 'Copying the mysql-connector files to the YCSB environment ...'
	cd $HOME_NEW
	cd ycsb-0.11.0/lib
	cp /usr/share/java/mysql-connector-java-5.1.38.jar .

	echo 'Editing db.properties in jbc-binding/conf to MySQL details ...'
	cd $HOME_NEW
	cd ycsb-0.11.0/jdbc-binding/conf/

	sed -i '19s/.*/db.driver=com.mysql.jdbc.Driver/' db.properties
	sed -i '20s/.*/db.url=jdbc:mysql:\/\/localhost:3306\/BenchTest/' db.properties
	sed -i '21s/.*/db.user=root/' db.properties
	sed -i '22s/.*/db.passwd=password/' db.properties

	echo 'Executing workload a (heavy with 50/50% Mix of Reads/Writes) against MySQL ...'
	cd $HOME_NEW
	cd ycsb-0.11.0
	./bin/ycsb load jdbc -P ./jdbc-binding/conf/db.properties -P workloads/workloada
fi
