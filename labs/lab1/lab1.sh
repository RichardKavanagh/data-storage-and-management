#!/bin/sh
# the script is licensed under the MIT license.

# bash options
#set -e

# commands used: 
# ls, cd, man, echo, mkdir, rm, tac, rev, top, ps, grep, kill, vmstat, du, factor, cut


function main {
	echo 'List a directory with most recently modified files first'
	ls -1t

	echo 'List a directory with most recently modified files last'
	ls -1rt

	echo 'Change the current working directory to /usr/bin'
	cd /usr/bin
	cd .

	echo 'Find info on the grep command'
	man grep

	echo 'Output the messahe Hello World!'
	echo 'Hello World!'

	echo 'Create a new file names my_file.txt'
	touch my_file.txt

	echo 'Create a new directory'
	mkdir test_dir

	echo 'Delete a directory'
	rm -r test_dir

	echo 'Create a new file containing some text'
	echo 'This is text' > my_file.txt

	echo 'Display the contents of a file backwards'
	tac my_file.txt | rev

	echo 'Which process is consuming most of the CPU for your VM?'
	top

	echo 'What is the process id associated with the current terminal session?'
	ps aux | grep 'terminal'  
	echo $PPID

	echo 'How do you kill a process?'
	kill -p $PPID

	echo 'Investigate the stats of your VM'
	vmstat

	echo 'How much disk space is available at /dev/sda1'
	du /dev/sda1

	echo 'Assign and then dosplay a variable'
	count=63
	echo $count

	echo 'Exmaple of the factor command'
	factor 64

	echo 'Remove everything except the factors output'
	factor 64 | cut -d " " -f2- 

}

function tabname {
  printf "\e]1;$1\a"
}

function winname {
  printf "\e]2;$1\a"
}

main