#!/bin/bash
# Script to Compress files which are X day's old and Delete which are y day's old. 
# Input file for logs or tar.gz "'APP_ID' 'FILE_TYPE' 'X/Y days old' " 
# 
# Author: Darshan S Mahendrakar
# Date Created: 08/12/15

# Logging Files and Directories
TMP_TAR_LOG='/tmp/toTar.tmp'
TMP_DELETE_FILE='/tmp/toDelete.tmp'
DELETE_LOG=/root/delete.log
FILE_PATH=/var/log/lz
TAR_LOG=/tmp/delete_tar.log
TMP_DIR=/tmp/tar_dir
DATE=$(date +\%Y\%m\%d_\%H\%M)

# User Execution Check
function userCheck() {
	if [[ $USER = "lzadmin" ]]; then 
		sourceArguments
	else
		echo "This script must be executed as LZADMIN ONLY !"
                exit 1
		sourceArguments
	fi
}

function sourceArguments() {
	#echo "I am in sourcearguments"
		cat $source_file | while read appid type days;
	do
		echo "$appid $type $days";
			APP_ID=$appid
			FILE_TYPE="$type"
			NO_OF_DAYS=$days
		validateArguments
		 echo "im in validate arguments"
		findFiles
		 echo "im in find files"
	done
}

# function to validate the given arguments
function validateArguments() {
	# checking argument APP_ID
	if [ -z "$APP_ID" ]
	then
		echo "APP ID not specified"
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
#	echo  "${FILE#*.}"
	ext=${FILE_TYPE#*.}
	echo "$ext"
	if [ $ext == "tar.gz" ]; then
		echo "im in tar find files"
		find "$FILE_PATH/$APP_ID" -name  "${FILE_TYPE}"  -mtime  +$NO_OF_DAYS -type f  > $TMP_DELETE_FILE 
		cat $TMP_DELETE_FILE >> $DELETE_LOG
	
		# Function to Delete the tar files which are x number of days old
		deleteFiles
	else
		echo "im in finding *.* files "
		find "$FILE_PATH/$APP_ID"  -name  "${FILE_TYPE}"  -mtime  +$NO_OF_DAYS -type f  > $TMP_TAR_LOG
		mkdir -p "${TMP_DIR}/${APP_ID}_${DATE}"
		echo "creating dir under tmp/tar_dir"
	
		# Function to move file to tmp dir to tar the files which are y number of days only
		moveFiles
fi
}

# function that deletes files that are recorded in TMP_DELETE_FILE
function deleteFiles() {
	for file in `cat $TMP_DELETE_FILE`
	do
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
		if [  -f "$mvname" ]	
		then
			echo "moving $mvname to ${TMP_DIR}/${APP_ID}_${DATE}"
			mv "$mvname" "${TMP_DIR}/${APP_ID}_${DATE}"
		else 
			echo "NO FILES FOUND TO TAR" 
			rm -rf "${TMP_DIR}/${APP_ID}_${DATE}"
			exit 1
		fi	
	done
	tarDir
}

# function to tar the files which are x number of days old
function tarDir () {
	cd "${TMP_DIR}" && tar cPf "${APP_ID}_${DATE}.tar.gz" "${APP_ID}_${DATE}"
	mv "${APP_ID}_${DATE}.tar.gz" "${FILE_PATH}/${APP_ID}/"
	rm -rf "${APP_ID}_${DATE}"
}

# Main Arguments
source_file=$1
userCheck

