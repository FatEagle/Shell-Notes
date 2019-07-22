#/bin/bash

print_hello=$(echo -n "hello")
print_word=$(echo ",word")

echo $print_hello
echo $print_word

time=`ls -l`
echo $time