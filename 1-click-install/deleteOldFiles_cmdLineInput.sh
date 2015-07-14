#!/bin/bash

# Author: Darshan S Mahendrakar
# Date Created: 07/13/15

# Last Updated: 07/14/15

## Initializing variables
ROOT_PATH=$1
FILE_TYPE=$2
NO_OF_DAYS=${!#}

TMP_DELETE_FILE=/tmp/toDelete.tmp
DELETE_LOG=delete.log

# function to validate the given arguments
function validateArguments() {
	# checking argument ROOT_PATH
	if [ -z $ROOT_PATH ]
		then
			echo "ROOT path not specified"
			exit 1
	fi
	
	# checking argument FILE_TYPE
	if [ -z $FILE_TYPE ]
		then
			echo "File type not specified"
			exit 1
	fi
	
	# checking argument NO_OF_DAYS
	if [ -z $NO_OF_DAYS ]
		then
			echo "ROOT path not specified"
			exit 1
	fi
}

# function to find files older than X days
function findFiles() {
	find $ROOT_PATH -type f -name $FILE_TYPE -mtime +$NO_OF_DAYS > $TMP_DELETE_FILE
	#commong log file
	cat $TMP_DELETE_FILE >> $DELETE_LOG
}

# function that deletes files that are recorded in TMP_DELETE_FILE
function deleteFiles() {
	for file in $(cat $TMP_DELETE_FILE)
	do
		echo "$file"
		# rm -rf $file
	done
}

# main_program
validateArguments
findFiles
deleteFiles

