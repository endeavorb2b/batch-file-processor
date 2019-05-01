#!/bin/bash
script=$1 
file=$2

if [ -z "$script" ]
then
   read -p "Name of script:" script;
fi

if [ -z "$file" ]
then
   read -p "File name in /data:" file;
fi

export FILE=$file
export SCRIPT=$script

./init.sh

