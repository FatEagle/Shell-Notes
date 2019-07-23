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

