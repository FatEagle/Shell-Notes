#!/bin/bash

for name in aa bb cc dd
do
    echo $name
done

echo '\nsecond case'

for word in "I don't know if this'll work"
do 
    echo $word
done

echo '\nthird case:'
for word in I don\'t know if "this'll" work
do
    echo $word
done

echo "\nuse a list variable in for statement"

list="aa bb cc"
list=${list}" dd"
for word in $list
do
    echo $word
done

echo "\nuse a list from command"
for file_name in $(ls)
do
    echo $file_name
done

echo "\n define yourself IFS"
# define yourself IFS(internal field separator)
# the default value is space, tab and enter.
IFS_OLD=$IFS
IFS=$'\n'
for file_info in $(ls -l)
do
    echo $file_info
done
# define more than one values to IFS
# IFS=$:;
IFS=$IFS_OLD

echo "read files in another method"
for file_path in ./md_images/*
do 
    echo $file_path
done

echo 

path=$(pwd)
for file_path in $path/*
do
    echo $file_path
done

echo 

for file_name in $(ls $path)
do
    echo $file_name
done

echo "C style for statement"

for (( i=1; i <=10; i++ ))
do
    echo $i
done

for (( a=1, b=10; a <=10; a++, b-- ))
do  
    echo "$b - $a"
done