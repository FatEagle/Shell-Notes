# shell 脚本笔记


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
![expr支持的运算符](images/expr_operations.png)

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
