#!/bin/bash
# add.sh

if [ ! -n "$1" ]
then
    echo "You should input the first parameter."
    exit 2
fi

if [ ! -n "$2" ]
then    
    echo "You shoule input the second parameter."
    exit 2
fi

total=$[ $1 + $2 ]
echo "First parameter is $1."
echo "Second parameter is $2."
echo "Total equals $total."
