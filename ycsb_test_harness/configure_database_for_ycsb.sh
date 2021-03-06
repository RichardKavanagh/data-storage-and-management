#!/bin/bash

# Commands used exec, sudo, echo, if, cd, sed

HOME_NEW=/home/hduser
cd $HOME_NEW

echo -e '\tConfiguring YCSB for database:' $1

if [ "$1" == "mysql" ]; then

	echo -e "\tConfiguring the mysql-connector files to the YCSB environment ..."
	cd $HOME_NEW
	cd ycsb-0.11.0/lib
	cp /usr/share/java/mysql-connector-java-5.1.38.jar .

	cd $HOME_NEW
	cd ycsb-0.11.0/jdbc-binding/conf/

	sed -i '19s/.*/db.driver=com.mysql.jdbc.Driver/' db.properties
	sed -i '20s/.*/db.url=jdbc:mysql:\/\/localhost:3306\/BenchTest/' db.properties
	sed -i '21s/.*/db.user=root/' db.properties
	sed -i '22s/.*/db.passwd=password/' db.properties
fi
if [ "$1" == "cassandra-cql" ]; then

	echo 'Inserting test data to Cassandra ...'
	$HOME_NEW/cassandra/bin/cqlsh -f ./lab6/insert_test_data.cql
fi
cd $HOME_NEW/data-storage-and-management/ycsb_test_harness

echo -e '\tFinished YCSB configuration for:' $1
