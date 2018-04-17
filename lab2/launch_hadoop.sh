#!/bin/bash

# Commands used
# exec, cd, jps, echo

HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof
cd $HOME_NEW
cd hadoop

echo 'Formating the HDFS namenode & starting hadoop services ...'
bin/hdfs namenode -format
sbin/start-dfs.sh
sbin/start-yarn.sh

echo 'Listing the instrumented jvms ...' 
jps
