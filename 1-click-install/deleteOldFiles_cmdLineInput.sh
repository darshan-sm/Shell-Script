#!/bin/bash

#Author: Darshan S Mahendrakar
#Date: 07/13/15
#mkdir /tmp/deleteOld && cd /tmp/deleteOld
#touch fileName.txt


#path=/root/darshan/*
#file_type =  "*.txt, *.wsp"

echo "Enter The Path"
  read path
echo "Enter the file type"
  read file_type
echo "Enter how many days old files"
  read days

find $path -name "$file_type" -mtime "$days" -type f -exec cat > /tmp/output.txt {} \;

# >> /tmp/deleteOld/fileName.txt 


#rm -rf /tmp/deleteOld/fileName.txt
