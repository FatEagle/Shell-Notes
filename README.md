# shell 脚本笔记

## 快速入门

### Control Flow
#### if
```shell
if command
then
    commands
fi
```
如果if后的command的退出状态码是0（执行成功)，那么then后的命令会被执行

等价形式，只是利用`;`把then放在了同一行
```shell
if command; then
    commands
fi
```

```shell
if command
then
    commands
else
    commands
fi
```

```shell
if command1
then
    commands
elif command2
then
    commands
fi
```

#### case
```shell
case variable in
pattern1 | pattern2) commands1;;
pattern3) commands2;;
esac
```

#### for
```shell
for var in list:
do
    commands
done
```

类C语言风格的for
```shell
for (( variable assignment ; condition ; iteration process ))
do
    commands
done

# example
for (( i=1; i <= 10; i++ ))
do
    echo $i
done

for (( a=1, b=10; a <=10; a++, b-- ))
do  
    echo "$b - $a"
done
```

#### while
```shell
while test command
do
    commands
done
```

```shell
#!/bin/bash
# while_statement.sh

i=5
while [ $i -gt 0 ]
do
    echo $i
    i=$[ $i - 1 ]
done
```

#### until
只有test命名退出状态码不是0时执行
```shell
until test commands
do
    other commands
done
```

#### 循环控制 break 和 continue
```shell
break [n]
continue [n]
```
n指定跳出的层数，不写n时默认为1，当层。

### 处理用户输入
* $0 程序名
* $1 第一个参数
* $n 第n个参
* $# 输入参数的数量

```shell
total=$[ $1 + $2 ]
echo "First parameter is $1."
echo "Second parameter is $2."
echo "Total equals $total."
```

使用`${!n}`动态获取第n个参数的值
```shell
total=0
for (( i=1; i <= $#; i++ ))
do 
    echo "$i parameter is ${!i}"
    total=$[ $total + ${!i} ]
done
echo "Total equals $total."
```


## 必须要加入 `#!/bin/bash`
shell脚本会读取第一行， 来获取使用哪个shell运行脚本。


## 查看环境变量
```shell
echo $PATH
```
PATH环境变量被设置成只在一组目录中查找命令。将shell脚本所在的目录添加到PATH环境变量中，就可以运行shell。


## 注释
使用`#`进行注释


## 执行数学运算
**要非常注意：** bash shell 只支持整数运算 4 / 3 = 1
```shell
[Charles Shell]$ echo $[4 / 3]
1
```
### expr 命令
注意：运算符两边要加空格, 有一些字符需要转移后使用
```shell
expr 1 + 2
expr 2 \* 3
```

```shell
#!/bin/bash
# An example of using the expr command
var1=10
var2=20
var3=$(expr $var2 / $var1)
echo The result is $var3
```
expr支持的运算符
![expr支持的运算符](md_images/expr_operations.png?raw=true)

### 使用方括号`$[运算式]`
```shell
[Charles Shell]$ var1=$[1 + 2]
[Charles Shell]$ echo $var1
3
[Charles Shell]$ var2=$[$var1 * 2]
[Charles Shell]$ echo $var2
6
```

```shell
#!/bin/bash
var1=100
var2=50
var3=45
var4=$[$var1 * ($var2 - $var3)]
echo The final result is $var4
```

### 浮点数解决方案 bc —— bash内建计算器
bc实际上是一种编程语言
`bc -q`省略欢迎信息
在脚本中使用bc
```shell
variable=$(echo "options; expression" | bc)
```

bc支持：
* 数字（整数和浮点数）
* 变量（简单变量和数组）
* 注释（# 或 /* */)
* 表达式
* 编程语句（if-then 等）
* 函数
```shell
[Charles Shell]$ bc
bc 1.06
Copyright 1991-1994, 1997, 1998, 2000 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'. 
12 * 5.4
64.8

1 + 2
3
quit
[Charles Shell]$ bc -q
# 浮点数使用scale指定保留位数
1/2
0
scale=4
1/2
.5000
1/3
.3333
2/3
.6666

var1 = 10
var1 * 2
20
var2 = var1 / 5
print var2
2.0000
quit
```

```shell
#!/bin/bash
# bc.sh
var1=$(echo "scale=4; 3.44 / 5" | bc)
echo The answer is $var1
```

```shell
 #!/bin/bash
 # bc2
var1=10.46
var2=43.67
var3=33.2
var4=71
var5=$(bc << EOF
scale = 4
a1 = ( $var1 * $var2)
b1 = ($var3 * $var4)
a1 + b1
EOF
)
echo The final answer for this mess is $var5
```


## 显示信息 echo
1. 直接显示字符`echo Hello world`
2. 使用单引号或双引号`echo "Hello world"` 或 `echo 'Hello world'`
3. `-n`参数去掉换行符 `echo -n "Hello " ; echo "world"`


## 变量

### 环境变量
使用`set`命令可以查看当前环境的完整环境变量列表

### 用户变量
* 使用变量：`$变量名`或`${变量名}`使用环境变量，后者更提供了更明确的变量名，
    ```shell
    welcome="Hello"
    echo $welcome   # Hello
    echo ${welcome},world # Hello,world
    ```

* 定义变量：`变量名=变量值`，注意等号的两边不能有空格。shell脚本会自动决定变量值的数据类型。在脚本的整个生命周期里，shell脚本中定义的变量 会一直保持着它们的值，但在shell脚本结束时会被删除掉。
    ```shell
    welcome="Hello world"
    positive_number=12
    negative_number=-12

    value1=10
    value2=$value1
    echo The resulting value is $value2
    ```

### 命令替换(将命令的结果赋值给变量)
* 使用反引号字符"`"
* 使用`$()`的形式

```shell
# generate_log.sh
today=$(date +%y%m%d)
ls -al /usr/bin > log.$today
```

## 重定向输入和输出
### 输出重定向
`command > outputfile`, 如果outputfile存在，会用新文件覆盖原有文件。

`command >> outputfile`, 这条命令会在文件后追加command的输出。

### 输入重定向
`command < inputfile`, 如`wc < README.md`
`command << marker`, 内联输入重定向（inline input redirection)。使用这种方法直接在shell界面上输入要重定向到command的命令，而无需使用文件进行重定向。例如
```shell
# wc的输出分别对应  文本行数 文本词数 文本字节数
[Charles Shell]$ wc << EOF
> haha
> 1234
> 12345
> 
> 678
> EOF
       5       4      21
```

## 管道（piping）（将一个命令的输出作为另一个命令的输入）
`command1 | command2`, command1的输出作为command2的输入。Linux会同时运行这两个命令，并在系统的内部将其连接起来。在第一个命令产生输出后会立即送入第二个命令。数据传输不会用到任何中间文件或缓冲区
```shell
[Charles Shell]$ ls -al | grep README.md 
-rw-r--r--@  1 Charles  staff  1725 Jul 22 10:23 README.md
```
如果不使用管道，而使用重定向，则需要一个中间文件
```shell
[Charles Shell]$ ls -al > temp.txt
[Charles Shell]$ grep README.md < temp.txt
-rw-r--r--@  1 Charles  staff  1725 Jul 22 10:23 README.md
```

在一条命名中可以使用任意条管道
```shell
$ rpm -qa | sort | more
```
可以搭配重定向
```shell
$ rpm -qa | sort > rpm.list
```


## 退出脚本
* Linux使用`$?`查看上一条命令的退出状态码。
* 一个成功的命令的退出状态码是0。
* 退出状态码是0或正整数, 范围在0-255

在脚本中使用
```shell
#!/bin/bash
# testing the exit status
var1=10
var2=30
var3=$[$var1 + $var2]
exit $var3
```


## Control Flow

### if
```shell
if command
then
    commands
fi
```
如果if后的command的退出状态码是0（执行成功)，那么then后的命令会被执行

等价形式，只是利用`;`把then放在了同一行
```shell
if command; then
    commands
fi
```

```shell
if command
then
    commands
else
    commands
fi
```

```shell
if command1
then
    commands
elif command2
then
    commands
fi
```

示例：
```shell
#!/bin/bash
# Testing nested ifs - use elif & else #
testuser=NoSuchUser

if grep $testuser /etc/passwd
then
   echo "The user $testuser exists on this system."
elif ls -d /home/$testuser
then
   echo "The user $testuser does not exist on this system."
   echo "However, $testuser has a directory."
else
   echo "The user $testuser does not exist on this system."
   echo "And, $testuser does not have a directory."
fi
```

### test
#### 方括号形式表示
**注意，第一个方括号之后和第二个方括号之前必须加上一个空格，否则就会报错。**
```shell
if [ condition ]
then
    commands
fi
```
#### 直接使用命令
格式
```shell
test condition
```

只写`test` 退出状态码 0
```shell
#!/bin/bash
# Testing the test command #
my_variable="Full"

if test $my_variable
then
   echo "The $my_variable expression returns a True"
else
   echo "The $my_variable expression returns a False"
fi
$
$ ./test6.sh
The Full expression returns a True 
```

#### test支持的比较形式
test 支持3类判断
* 数值比较
* 字符串比较
* 文件比较

**1.数值比较**
![test_value_compare](md_images/test_value_compare.png?raw=true)


**注意**，bash shell只能处理整数，涉及到浮点数的条件会出错
```shell
[Charles Shell]$ test 1 -eq 2[Charles Shell]$ $?
bash: 1: command not found
[Charles Shell]$ test 1 -eq 1
[Charles Shell]$ $?
bash: 0: command not found
```

```shell
#!/bin/bash
# if_statement.sh
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
```

**2. 字符串比较**
![test_string_compare](md_images/test_string_compare.png?raw=true)

字符串比较时，大小写和标点都会考虑。
**注意：**
* 要考虑">"和"<"号的转义，写成"\>"
* 不同的命令在处理大写字母和小写字母上的顺序不同，有时是大写字符大于小写字符，有时相反。

**3. 文件比较**
用于检测文件状态
![test_file_compare](md_images/test_file_compare.png?raw=true)

### 复合条件
* [ condition1 ] && [ condition2 ]
* [ condition1 ] || [ condition2 ]

```shell
#!/bin/bash
# testing compound comparisons

if [ -d $HOME ] && [ -w $HOME/testing ] then
   echo "The file exists and you can write to it"
else
   echo "I cannot write to the file"
fi
```

### 用于数学表达式的双括号
```shell
(( expression ))
```
除了标准数学运算符 + - * \ ,还支持如下的表
![symbol](md_images/symbol.png?raw=true)

```shell
#!/bin/bash
# symbol.sh

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
```

### 使用双方括号利用模式匹配处理字符串
`[[ expression ]]`，双方括号中可以使用模式匹配来处理字符串
```shell
#!/bin/bash
# using pattern matching 
if [[ $USER == r* ]]
then
echo "Hello $USER"
else 5
    echo "Sorry, I do not know you"
fi
```

### case
```shell
case variable in
pattern1 | pattern2) commands1;;
pattern3) commands;;
esac
```

```shell
#!/bin/bash
# using the case command #
case $USER in
rich | barbara)
    echo "Welcome, $USER"
    echo "Please enjoy your visit";;
testing)
    echo "Special testing account";;
jessica)
    echo "Do not forget to log off when you're done";;
*)
    echo "Sorry, you are not allowed here";;
esac
```

### for
```shell
for var in list:
do
    commands
done
```

```shell
#!/bin/bash
# for_statement.sh

for name in aa bb cc dd
do
    echo $name
done

echo '\nsecond case'

for word in "I don't know if this'll work"
do 
    echo $word
done

echo '\nthird case:'
for word in I don\'t know if "this'll" work
do
    echo $word
done

echo "\nuse a list variable in for statement"

list="aa bb cc"
list=${list}" dd"
for word in $list
do
    echo $word
done

echo "\nuse a list from command"
for file_name in $(ls)
do
    echo $file_name
done

echo "\n define yourself IFS"
# define yourself IFS(internal field separator)
# the default value is space, tab and enter.
IFS_OLD=$IFS
IFS=$'\n'
for file_info in $(ls -l)
do
    echo $file_info
done
# define more than one values to IFS
# IFS=$:;
IFS=$IFS_OLD

echo "read files in another method"
for file_path in ./md_images/*
do 
    echo $file_path
done

echo 

path=$(pwd)
for file_path in $path/*
do
    echo $file_path
done

echo 

for file_name in $(ls $path)
do
    echo $file_name
done
```

C语言风格的forxunhuan
```shell
for (( variable assignment ; condition ; iteration process ))
do
    commands
done
```

```shell
for (( i=1; i <= 10; i++ ))
do
    echo $i
done
```

### while
```shell
while test command
do
    commands
done
```

```shell
#!/bin/bash
# while_statement.sh

i=5
while [ $i -gt 0 ]
do
    echo $i
    i=$[ $i - 1 ]
done
```

### until
只有test命名退出状态码不是0时执行
```shell
until test commands
do
    other commands
done
```

```shell
#!/bin/bash
# until_statement.sh

var=10

until [ $var -eq 0 ]
do 
    echo $var
    var=$[ $var - 1 ]
done
```
### 循环控制 break 和 continue
```shell
for var1 in 1 2 3 4 5 6 7 8 9 10
do
    if [ $var1 -eq 5 ]
    then
        break
    fi
    echo "Iteration number: $var1"
done
echo "The for loop is completed"
``` 

break可以指定跳出循环的层数
```shell
for (( a = 1; a < 4; a++ ))
do
    echo "Outer loop: $a"
    for (( b = 1; b < 100; b++ ))
    do
        if [ $b -gt 4 ]
        then
            break 2 
        fi
        echo "    Inner loop: $b"
    done
done
```

### 将循环的输出送到一个文件中
```shell
for file in /home/rich/*
     do
       if [ -d "$file" ]
       then
          echo "$file is a directory"
       elif
          echo "$file is a file"
       fi
done > output.txt
```

## 处理用户输入
* $0 程序名
* $1 第一个参数
* $n 第n个参
* $# 输入参数的数量

```shell
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

```

使用`${!n}`动态获取第n个参数的值
```shell
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
```
