#!/bin/bash

# Commands used
# echo, apt-get, addgroup, useradd, adduser, sed, wget, tar, echo
# ln, mkdir, chmod, cd, rm, exec, sudo, ssh-keygen, ssh-keyscan

echo 'Starting Hadoop installation ...'

echo 'Installing dependencies ...'
dpkg --configure -a
apt-get update
apt-get install openjdk-8-jre openjdk-8-jdk ssh rsync -y

echo 'Configuring hadoop user & groups ...'
./helper_scripts/add_user.sh

echo 'Disabling IPv6 ...'
CF=/etc/sysctl.conf
sed -i '$ a net.ipv6.conf.all.disable_ipv6=1' $CF
sed -i '$ a net.ipv6.conf.default.disable_ipv6=1' $CF
sed -i '$ a net.ipv6.conf.lo.disable_ipv6=1' $CF

HOME_NEW=/home/hduser
echo 'Current user id='
id
exec sudo -u hduser /bin/sh - << eof
echo 'New user id='
id
echo 'New Home path='
echo $HOME_NEW

echo 'Downloading hadoop for apache.org ...'
cd $HOME_NEW
wget http://www-eu.apache.org/dist/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz
tar xzf hadoop-2.7.5.tar.gz
ln -s hadoop-2.7.5 hadoop

echo 'Create a temp/data directory for hadoop ...'
mkdir tmp
mkdir hdfs

echo 'Deleting temp config files ...'
cd hadoop/etc/hadoop/
rm mapred-site.xml.template core-site.xml hdfs-site.xml

echo 'Downling new config files from Github ...'
wget https://raw.githubusercontent.com/RichardKavanagh/data-storage-and-management/master/labs/hadoop_config/core-site.xml
wget https://raw.githubusercontent.com/RichardKavanagh/data-storage-and-management/master/labs/hadoop_config/hdfs-site.xml
wget https://raw.githubusercontent.com/RichardKavanagh/data-storage-and-management/master/labs/hadoop_config/map-red.xml

echo 'Setting up ssh to access hadoop server ...'
mkdir $HOME_NEW/.ssh/
ssh-keygen -t rsa -P "" -f $HOME_NEW/.ssh/id_rsa
mkdir -p $HOME_NEW/.ssh/authorized_keys
cat $HOME_NEW/.ssh/id_rsa.pub > $HOME_NEW/.ssh/authorized_keys/id_rsa.pub

echo 'Adding localhost to known_hosts (warning only suitable for test!) ...'
ssh-keyscan localhost >> /home/hduser/.ssh/known_hosts
ssh-keyscan 0.0.0.0 >> /home/hduser/.ssh/known_hosts

echo 'Editing java path in hadoop-env.sh  ...'
sed -i '25s/.*/export JAVA_HOME=\/usr\/lib\/jvm\/java-8-openjdk-amd64/' hadoop-env.sh

echo 'Finished Hadoop installation ...'
