#!/bin/bash
# To Delete the old files using *.format which is older than x number of days from source file.
# Cannot Run as ROOT USER. 
# To Execute create flat file and pass the source file as the parameter.

# Author: Darshan S Mahendrakar
# Date Created: 07/13/15
# Modified : 07/20/15



# Logging Deleted Files
TMP_DELETE_FILE=/tmp/toDelete.tmp
DELETE_LOG=/tmp/delete.log

# User Execution Check
function userCheck() {
	if [[ $USER = "root" ]]; then 
		echo "This script must NOT BE RUN AS root!" 
		exit 1
	else
		sourceArguments
	fi
}

function sourceArguments() {
	#echo "I am in sourcearguments"
		cat $source_file | while read filepath type days;
	do
		echo "$filepath $type $days";
			ROOT_PATH=$filepath
			FILE_TYPE="$type"
			NO_OF_DAYS=$days
		validateArguments
		# echo "im in validate arguments"
		findFiles
		# echo "im in find files"
		deleteFiles
		# echo "im in delete files"
	done

}

# function to validate the given arguments
function validateArguments() {
	# checking argument ROOT_PATH
	if [ -z "$ROOT_PATH" ]
		then
			echo "ROOT path not specified"
			exit 1
	fi

	# checking argument FILE_TYPE
	if [ -z "$FILE_TYPE" ]
	then
			echo "File type not specified"
			exit 1
	fi

	# checking arguemt NO_OF_DAYS
	if [ -z "$NO_OF_DAYS" ]
	then
			echo "Number of days not specified"
			exit 1
	fi
}

# function to find files older than X days
function findFiles() {
	
	find $ROOT_PATH -name  "${FILE_TYPE}"  -mtime  +$NO_OF_DAYS -type f  > $TMP_DELETE_FILE
	cat $TMP_DELETE_FILE >> $DELETE_LOG
}

# function that deletes files that are recorded in TMP_DELETE_FILE
function deleteFiles() {
	for file in `cat $TMP_DELETE_FILE`
	do
	 	# echo "$file"
		rm -f $file
	done
}

#Main Arguments
source_file=$1
userCheck

