#!/bin/bash

value=10
if (( $value * 2 > 15 ))
then
    echo "value * 2 > 15"
fi

# value=10
# if (( ${value} / 2 > 5))
# then
#     echo "value / 2 > 5"
# fi

val1=10
#
if (( $val1 ** 2 > 90 ))
then
    (( val2 = $val1 ** 2 ))
    echo "The square of $val1 is $val2"
fi

# result
# value * 2 > 15
# The square of 10 is 100