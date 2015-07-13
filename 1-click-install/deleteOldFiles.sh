#!/bin/bash

#Author: Darshan S Mahendrakar
#Date: 07/13/15

path=/root/darshan/*
file_type =  "*.txt, *.wsp"

for i in $file_type
        do
        find $path -name "$i" -mtime +90 -type f -delete
        done
