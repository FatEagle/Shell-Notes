#/bin/bash

function times2 {
    local value
    read -p "Enter a value: " value
    echo $[ $value * 2 ]
}

function add {
    if [ ! -n "$1" ]
    then
        echo "You should input the first parameter."
        exit 2
    fi

    total=0
    for number in $@
    do 
        total=$[ $total + $number ]
    done
    echo $total
}

result=$(times2)
echo "New value is $result."

echo

read -p 'The list of numbers: ' numbers
echo "the sum of numbers is $(add $numbers)"
