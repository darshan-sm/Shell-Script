#!/bin/bash
# Author: Darshan S Mahendrakar
# Date Created: 07/13/15

## Initializing variables
#ROOT_PATH=$filepath
#FILE_TYPE=$type
#NO_OF_DAYS=$days

#echo -----------$FILE_TYPE------------
TMP_DELETE_FILE=/tmp/toDelete.tmp
DELETE_LOG=/tmp/delete.log

# function to retrive pararmeters for given arguement

function sourceArguments() {
	echo "I am in sourcearguments"
#	export IFS=" "
#SOURCE_FILE /root/test/source
		cat $source_file | while read filepath type days;
	do
		echo "$filepath $type $days";
			ROOT_PATH=$filepath
			FILE_TYPE="$type"
			NO_OF_DAYS=$days
		validateArguments
		echo "im in validate arguments"
		findFiles
		echo "im in find files"
		deleteFiles
		echo "im in delete files"

	done

}

# function to validate the given arguments
function validateArguments() {
	# checking argument ROOT_PATH
	if [ -z "$ROOT_PATH" ]
		then
			echo "ROOT path not specified"
			exit 1
	else	
			echo "Root Path : ${ROOT_PATH} is good"
	fi
	
	# checking argument FILE_TYPE
	if [ -z "$FILE_TYPE" ]
	then
			echo "File type not specified"
			exit 1
	else
			echo "File Type : ${FILE_TYPE} is good"
	fi
	
	# checking argument NO_OF_DAYS
	if [ -z "$NO_OF_DAYS" ]
	then
			echo "Number of days not specified"
			exit 1
	else
		echo "Number of days : ${NO_OF_DAYS} is good"
	fi
}

# function to find files older than X days
function findFiles() {
	
	find $ROOT_PATH -name  "${FILE_TYPE}"  -mtime  +$NO_OF_DAYS -type f  > $TMP_DELETE_FILE
	echo "find ${ROOT_PATH} -name   ${FILE_TYPE}  -mtime  +${NO_OF_DAYS} -type f"
	cat $TMP_DELETE_FILE >> $DELETE_LOG
}

# function that deletes files that are recorded in TMP_DELETE_FILE
function deleteFiles() {
	for file in `cat $TMP_DELETE_FILE`
	do
		echo "$file"

		rm -f $file

		#echo "$file-------> Deleted 2"
	done
}

#Main Arguments
echo "I am in main"
source_file=$1
sourceArguments
#validateArguments
#findFiles
#deleteFiles

