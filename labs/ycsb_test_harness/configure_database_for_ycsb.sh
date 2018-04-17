#!/bin/bash

# Commands used exec, sudo, echo, if, cd, sed

HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof
cd $HOME_NEW

echo -e '\tConfiguring YCSB for database:' $1
if [ "$1" == "mysql" ]; then

	echo -e "\t\tConfiguring the mysql-connector files to the YCSB environment ..."
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

cd $HOME_NEW/data-storage-and-management/labs/ycsb_test_harness

echo -e '\tFinished ycsb configuration for:' $1
