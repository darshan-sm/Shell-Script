#!/bin/bash
#Author: Darshan S Mahendrakar
#Date:07/13/15

mkdir -p /tmp/1837 && cd /tmp/1837

path=/root/darshan/
file_types="*.txt *.wsp"

#echo $file_types
for i in $file_types
do 
	find $path -name "$i" -mtime +90 -type f -delete
done

rm -rf /tmp/1837
