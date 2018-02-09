#!/bin/bash

# Commands used
# cd, mkdir, wget, echo, cat

exec sudo -u hduser /bin/sh - << eof

echo 'Downloading Ulysses.txt'
cd /tmp
mkdir gutenberg
cd gutenberg
wget http://www.gutenberg.org/files/4300/4300-0.txt
cd /home/hduser/hadoop

echo 'Copying ulysses text file to HDFS ...'
bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/hduser
bin/hdfs dfs -mkdir /user/hduser/gutenberg
bin/hdfs dfs -copyFromLocal /tmp/gutenberg/* /user/hduser/gutenberg
 
echo 'Running Map-Reduce word count example ...'
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.9.0.jar wordcount /user/hduser/gutenberg /user/hduser/gutenberg-output

echo 'Listing output ...'
bin/hdfs dfs -ls /user/hduser/gutenberg-output

echo 'Copying output back to local file system ...'
mkdir /tmp/gutenberg-output 
bin/hdfs dfs -get /user/hduser/gutenberg-output/part-r-00000 /tmp/gutenberg-output

cd /tmp/gutenberg-output
cat part-r-00000
