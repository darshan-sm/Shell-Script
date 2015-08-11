#!/bin/bash
# To Delete the old files using *.format which is older than x number of days from source file.
# Cannot Run as ROOT USER. 
# To Execute create flat file and pass the source file as the parameter.
# Author: Darshan S Mahendrakar
# Date Created: 07/13/15
# Modified : 07/20/15

# Logging Deleted Files
TMP_TAR_LOG='/tmp/toTar.tmp'
TMP_DELETE_FILE='/tmp/toDelete.tmp'
DELETE_LOG=/root/delete.log
FILE_PATH=/var/log/lz
TAR_LOG=/tmp/delete_tar.log
TMP_DIR=/tmp/tar_dir

# User Execution Check
function userCheck() {
	if [[ $USER = "darshan" ]]; then 
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
		 echo "im in validate arguments"
		findFiles
		 echo "im in find files"
	#	tarDir
	#	 echo "Im in Tarring directory" 
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
	if [ $FILE_TYPE == "*.tar.gz" ]; then
		echo "im in tar find files"
		find "$FILE_PATH/$ROOT_PATH" -name  "${FILE_TYPE}"  -mtime  +$NO_OF_DAYS -type f  > $TMP_DELETE_FILE 
		echo "find "${FILE_PATH}/${ROOT_PATH}"  -name  "${FILE_TYPE}"  -mtime  +$NO_OF_DAYS -type f  > $TMP_DELETE_FILE "
		cat $TMP_DELETE_FILE >> $DELETE_LOG
		deleteFiles
	else
		echo "im in finding *.* files "
		find "$FILE_PATH/$ROOT_PATH"  -name  "${FILE_TYPE}"  -mtime  +$NO_OF_DAYS -type f  > $TMP_TAR_LOG
		echo "find "$FILE_PATH/$ROOT_PATH"  -name  "${FILE_TYPE}"  -mtime  +$NO_OF_DAYS -type f  > $TMP_TAR_LOG "
		mkdir -p "/${TMP_DIR}/${ROOT_PATH}"
		echo "creating dir under tmp/tar_dir"
		moveFiles
fi
}

# function that deletes files that are recorded in TMP_DELETE_FILE
function deleteFiles() {
	for file in `cat $TMP_DELETE_FILE`
	do
		echo "im in deleteFiles" 
		filename=$file
		echo "Deleting $filename"
		if [ -f $filename ]
		then
			rm -rf $filename
		else
			echo "No tar files to delete"
			exit 1
		fi
	done

}

# function to move files recorded in TMP_TAR_LOG
function moveFiles () {
	for move_file in `cat $TMP_TAR_LOG`
	do 	
		
		mvname=$move_file
		echo "Moving $mvname"
		if [  -f "$mvname" ]	
		then
			echo "moving $mvfile to ${TMP_DIR}/${ROOT_PATH}"
			mv "$mvname" "${TMP_DIR}/${ROOT_PATH}"
		#	cd "${TMP_DIR}" && tar cvf ${ROOT_PATH}.tar.gz ${ROOT_PATH}/
		else 
			echo "NO FILES FOUND TO TAR" 
			rm -rf "/${TMP_DIR}/${ROOT_PATH}"
			exit 1
			
		fi	
		tarDir
	done
}

# function to tar the files which are x number of days old
function tarDir () {
cd "${TMP_DIR}" && tar cvf ${ROOT_PATH}.tar.gz "${TMP_DIR}/${ROOT_PATH}"
mv ${ROOT_PATH}.tar.gz "${FILE_PATH}/${ROOT_PATH}"

}

#Main Arguments
source_file=$1
userCheck

