#!/bin/bash

# Commands used 
# wc, grep, cut, uniq, sed

yarn_l=yarn-hduser-nodemanager-pluto.log

echo 'Counting the lines in file ...'
wc -l yarn_l.log

echo 'A: Extract out the log entry associated with the FATAL error ..'
grep -A 9 'FATAL' yarn_l.log

echo 'B: Extract out a set of unique log entry dates  ...'
grep '^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}' yarn_l.log | cut -f 1 -d ' ' | uniq -c

echo 'C: Count the number of entries per date ...'
grep '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}' yarn_l.log | uniq -c

echo 'D: Extract out a set of unique HH:MM:SS time entries  ...' 
grep '[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}' yarn_l.log | cut -f 1 -d ',' | cut -f 2 -d ' ' | uniq

echo 'E: Count how many entries are associated with each of the unique HH:MM:SS time entries'
# grep the HH:MM:SS, cut out the string, count the unique instances, trim leading/trailing whitespace, sort numerically by first column
grep '[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}' yarn_l.log | cut -f 1 -d ',' | cut -f 2 -d ' ' | uniq -c | sed -e 's/^[ \t]*//;s/[ \t]*$//' | sort -n -k 1
