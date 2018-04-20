#!/bin/bash

# Commands used
# mkdir, exec, wget, tar, ln, sed, cd, rm

echo 'Starting Hbase installation ...'

echo 'Configuring hadoop user & groups ...'
../helper_scripts/add_user.sh

echo 'Creating /usr/data/hbase dir ...'
mkdir /usr/data
mkdir /usr/data/hbase

echo 'Granting hduser ownership ...'
cd /usr
chown -R hduser:hadoop data
chown -R hduser:hadoop data/*

HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof
cd $HOME_NEW

echo 'Downloading hbase from apache ...'
wget http://www-eu.apache.org/dist/hbase/1.2.6/hbase-1.2.6-src.tar.gz
tar xzf hbase-1.2.6-src.tar.gz
ln -s hbase-1.2.6-src hbase

echo 'Editing java path in conf/hbase-env.sh file ...' 
sed -i '27s/.*/export JAVA_HOME=\/usr\/lib\/jvm\/java-8-openjdk-amd64/' /home/hduser/hbase/conf/hbase-env.sh

echo 'Adding LD_LIBRARY_PATH entry to conf/hbase-env.sh file ...'
sed -i '$ a export LD_LIBRARY_PATH=/home/hduser/hadoop/lib/native/' /home/hduser/hbase/conf/hbase-env.sh

echo 'Deleting default hbase-site.xml file ...'
cd hbase/conf
rm hbase-site.xml

echo 'Downloading new hbase-site.xml ...'
wget https://gist.githubusercontent.com/RichardKavanagh/52d638a5a456d95808d45f7e4f6117a4/raw/e59870f810ebab40a3229826113e553eaf32e154/hbase-site.xml

echo 'Finished Hbase installation ...'
