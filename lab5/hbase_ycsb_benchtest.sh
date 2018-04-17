#!/bin/bash

# Commands used echo, exec sudo, cd, cat

echo 'Logging in as hduser ...'
HOME_NEW=/home/hduser
exec sudo -u hduser /bin/sh - << eof
cd $HOME_NEW

echo 'Dropping old Hbase usertable table ...'
cd hbase
cat drop_test_data_hbase.txt | /home/hduser/hbase shell

echo 'Creating a Hbase table called usertable with a single column family names cf1 ...'
cat insert_test_data_hbase.txt | /home/hduser/hbase shell

echo 'Loading Hbase data before running workload ...'
cd $HOME_NEW
cd ycsb-0.11.0
bin/ycsb load hbase098 -P workloads/workloada -cp /$HOME_NEW/hbase/conf -p table=usertable -p columnfamily=family

echo 'Execute ycsb workload a (heavy with 50/50% Mix of Reads/Writes) against Hbase ...'
bin/ycsb run hbase098 -P workloads/workloada -cp /$HOME_NEW/hbase/conf -p table=usertable -p columnfamily=family
