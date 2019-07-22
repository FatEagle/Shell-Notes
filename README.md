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
### 命令替换
