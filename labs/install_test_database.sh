#!/bin/bash

# Commands used
# if,else,fi, echo, useradd, apt-get, purge, rm, wget, mysql,tar, ln, mkdir

HOME_NEW=/home/hduser

function install_hduser {

	if getent passwd hduser > /dev/null 2>&1; then
	    echo "Hduser already exists, skipping ..."
	else
		echo 'Adding new user ...'
		USER=hduser
		PASS=password
		HOME_NEW=/home/hduser
		useradd -p $(openssl passwd -1 $PASS) -m $USER
		adduser hduser sudo
	fi
}


function install_mysql {

	echo 'Installing MySQL dependencies ...'
	dpkg --configure -a
	apt-get update
	apt-get install mysql-server mysql-client libmysql-java -y

	echo 'Purging MySQL packages ...'
	apt purge mysql* -y
	rm -rf /var/lib/mysql
	rm -rf /etc/mysql

	echo 'Reinstalling Mysql ...'
	apt install mysql-server mysql-client -y

	echo 'Downloading insert_test_data.sql script ...'
	wget https://gist.githubusercontent.com/RichardKavanagh/cb4c85a55a43478445722caa6f56fed2/raw/9e82fdb9aa54a02e54b7cd1230fc62ecc24a7c0c/insert_test_data.sql

	echo 'Creating MySQL database & test table ...'
	mysql --user="root" --password="password" --execute="CREATE DATABASE BenchTest";
	mysql --user="root" --password="password" --database="BenchTest" < insert_test_data.sql

	rm insert_test_data.sql
}


function install_mongodb {

	echo 'Downloading MongoDB ...'
	cd $HOME_NEW
	curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-3.2.10.tgz
	tar xzf mongodb-linux-x86_64-ubuntu1604-3.2.10.tgz
	ln -s mongodb-linux-x86_64-ubuntu1604-3.2.10 mongodb

	echo 'Creating data/db directory ...'
	cd /
	ln -s $HOME_NEW/mongodb data
	cd data
	mkdir -p db

	echo 'Launching MondoDB instance ...'
	cd $HOME_NEW
	cd mongodb

	bin/mongod --bind_ip 127.0.0.1 </dev/null &>/dev/null &
}


function main {

	install_hduser
	if [ $1 == 'mysql' ]
	then
		install_mysql
	elif [ $1 == 'mongodb' ]
	then
		install_mongodb
	else
		echo 'Error incorrect input: Exiting Script ...'
		exit 1
	fi
}

main $1
