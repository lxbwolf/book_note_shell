# 函数

1 函数的定义  
　　我们只需要简单写出名字,后面加小括号,然后相关的语句放在花括号里  
  语法:

```
 [function] function_name () {
      statements
      [return value]
 }
```

注：在调用一个函数之前必须先对它进行定义。

函数返回值只能是整数，一般用来表示函数执行成功与否，0表示成功，其他值表示失败。如果 return 其他数据，比如一个字符串，往往会得到错误提示：“numeric argument required”。

例子:

```
#!/bin/bash
funWithReturn(){
    echo "The function is to get the sum of two numbers..."
    echo -n "Input first number: "
    read aNum
    echo -n "Input another number: "
    read anotherNum
    echo "The two numbers are $aNum and $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
# Capture value returnd by last command
ret=$?
echo "The sum of two numbers is $ret !"
```

运行结果:

```
The function is to get the sum of two numbers...
Input first number: 25
Input another number: 50
The two numbers are 25 and 50 !
The sum of two numbers is 75 !
```

函数返回值在调用函数后通过`$?`来获取

删除函数用\`unset\` 加上 '.f' 选项, 如:

\`unset .f function\_name\`

如果希望直接从终端调用函数, 可以把函数定义在主目录下的.profile文件.



