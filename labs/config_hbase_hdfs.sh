#!/bin/bash

# Commands used 

echo 'Configuring Hbase to use Hadoop File System ...'

HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof
cd $HOME_NEW

echo 'Shutting down hadoop services ...'
cd hadoop
sbin/stop-dfs.sh
sbin/stop-yarn.sh 
cd $HOME_NEW

echo 'Shutting down hbase services ...'
cd hbase
bin/stop-hbase.sh
cd $HOME_NEW

echo 'Replacing hadoop configuration files ...'
cd hadoop/etc/hadoop
rm hdfs-site.xml
wget https://raw.githubusercontent.com/RichardKavanagh/data-storage-and-management/master/labs/hdfs_config/hdfs-site.xml
cd $HOME_NEW

echo 'Replacing hbase configuration files ...'
cd hbase/conf
rm hbase-site.xml
wget https://raw.githubusercontent.com/RichardKavanagh/data-storage-and-management/master/labs/hdfs_config/hbase-site.xml
cd $HOME_NEW

echo 'Editing /etc/hosts file ...'

/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' 
hostname 

echo 'Reformatiing the HDFS namenode ...'
cd hadoop
bin/hdfs namenode -format

echo 'Restarting Hadoop services ...'
sbin/start-dfs.sh
sbin/start-yarn.sh
cd $HOME_NEW

echo 'Restarting Hbase services ...'
cd hbase
bin/start-hbase.sh

echo 'Listing the instrumented jvms ...' 
jps