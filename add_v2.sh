#!/bin/bash
# add_v2.sh

if [ ! -n "$1" ]
then
    echo "You should input the first parameter."
    exit 2
fi

total=0
for (( i=1; i <= $#; i++ ))
do 
    echo "$i parameter is ${!i}"
    total=$[ $total + ${!i} ]
done
echo "Total equals $total."
