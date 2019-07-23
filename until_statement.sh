#!/bin/bash
# until_statement.sh

var=10

until [ $var -eq 0 ]
do 
    echo $var
    var=$[ $var - 1 ]
done