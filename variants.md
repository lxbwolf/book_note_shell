## 变量  

1 linux大小写敏感, 变量名取名要注意大小写,可以使用"$"来访问变量, 可以通过read命令将用户输入的值赋给一个变量  
2 给变量赋值时, 如果字符串中有空格,就必须用引号把它们引起来. 赋值时等号两边不能有空格  
3 变量在双引号中会用变量值替换, 在单引号中不会用变量值替换  
```
例：myvar=“Hi there！”
    echo $myvar
    echo "$myvar"
    echo ' $myvar'
    echo \$myvar

将会输出如下：
              Hi there！
              Hi there!
              $myvar
              $myvar```

4 环境变量一般都用大写字母, 为了与环境变量区分, 用户自定义的变量一般用小写字母  
5 对数组元素进行赋值  
　对数组元素赋值的一般形式是：数组名[下标]＝值，例如：
 ```
 $ city[0]=Beijing
 $ city[1]=Shanghai
 $ city[2]=Tianjin```

　一个数组的各个元素可以利用上述方式一个元素一个元素地赋值，也可以组合赋值。定义一个数组并为其赋初值的一般形式是：
 ```
 数组名=(值1 值2 … 值n) ```
　其中，各个值之间以空格分开。例如：
 ```
 $ A=(this is an example of shell script)
 $ echo ${A[0]} ${A[2]} ${A[3]} ${A[6]}
 this an example script
 $ echo ${A[8]}```

　由于值表中初值共有 7 个，所以 A 的元素个数也是 7 。 A[8] 超出了已赋值的数组 A 的范围，就认为它是一个新元素，由于预先没有赋值，所以它的值是空串。  
　若没有给出数组元素的下标，则数组名表示下标为 0 的数组元素，如 city 就等价于 city[0] 。

6 如果要列出数组中的所有元素,使用*或@作下标  
7 获取数组元素的个数  
```
$ echo ${#A[*]}```
8 数值比较常见的比较符
```
= -eq
!= -ne(not equal)
> -gt(greater than)
>= -ge(greater than or equal)
< -lt(less than)
<= -le ```
