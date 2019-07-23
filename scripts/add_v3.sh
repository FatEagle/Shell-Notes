#!/bin/bash
# add_v3.sh

if [ ! -n "$1" ]
then
    echo "You should input the first parameter."
    exit 2
fi

total=0
for number in $@
do 
    echo "parameter is $number"
    total=$[ $total + $number ]
done
echo "Total equals $total."
