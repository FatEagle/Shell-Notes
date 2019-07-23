#!/bin/bash
# while_statement.sh

i=5
while [ $i -gt 0 ]
do
    echo $i
    i=$[ $i - 1 ]
done
