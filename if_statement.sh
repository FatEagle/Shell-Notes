#!/bin/bash
value=10

if [ $value -gt 5 ]
then
    echo "Value great than 5!"
fi

benchmark=20
if [ $value -gt $benchmark ]
then
    echo "Value great than benchmarl"
else
    echo "Value less than or equal benchmark"
fi

# result:
# Value great than 5!
# Value less than or equal benchmark