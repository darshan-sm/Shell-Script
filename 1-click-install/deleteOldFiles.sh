#!/bin/bash

#Author: Darshan S Mahendrakar
#Date: 07/13/15

path=/root/darshan/*
LIST =  "*.txt  *.wsp"
filename = $LIST
find $path -name "$filename" -mtime +90 -type f -delete
