#!/bin/bash

array=(1 2 3 4 5)
for value in ${array[*]}
do
    echo $value
done

echo "The second number is ${array[1]}"

function echo_array {
    local new_array
    new_array=`echo "$@"`
    echo "Array in function is: ${new_array[*]}"
}

array=(1 2 3 4 5)
echo_array ${array[*]}

array=(
    "/path/to/111"
    "/path/to/222"
    "/path/to/333"
)
echo_array ${array[*]}

echo 'Return an array'

function return_array {
    local new_array
    new_array=($(echo "$@"))
    echo ${new_array[*]}
}

array=$(return_array 1 2 3 4 5)
echo $array

