#!/bin/bash

# Commands used echo, exec sudo, cd

echo 'Logging in as hduser ...'
HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof
cd $HOME_NEW


echo 'Creating a Hbase table called usertable with a single column family names cf1 ...'
cd hbase
./hbase shell ./hbase_table_commands.txt


## Does the version of ycsb im installing cover more than hbase 98 & 94 ??
echo 'Loading Hbase data before running workload ...'
bin/ycsb load hbase -P workloads/workloada -cp /$HOME_NEW/hbase/conf -p table=usertable -p columnfamily=family


echo 'Execute ycsb workload a (heavy with 50/50% Mix of Reads/Writes) against Hbase ...'
cd $HOME_NEW
cd ycsb-0.11.0
bin/ycsb run hbase -P workloads/workloada -cp /$HOME_NEW/hbase/conf -p table=usertable -p columnfamily=family
