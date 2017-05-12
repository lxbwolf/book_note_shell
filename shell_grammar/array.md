bash支持一维数组, 不支持多维数组, 不限定数组的大小.

**定义数组**

用括号来表示数组，数组元素用“空格”符号分割开。定义数组的一般形式为：

\`array\_name=\(value1 ... valuen\)\`

或

```
array_name=(
value0
value1
value2
value3
)
```

还可以单独定义数组的各个元素

```
array_name[0]=value0
array_name[1]=value1
array_name[2]=value2
```

可以不使用连续的下标，而且下标的范围没有限制



**读取数组**

\`${array\_name\[index\]}\`

使用@ 或 \* 可以获取数组中的所有元素,  如

```
${array_name[*]}
${array_name[@]}
```



**获取数组长度**

获取数组长度的方法与获取字符串长度的方法相同, 如

```
# 取得数组元素的个数
length=${#array_name[@]}
或者
length=${#array_name[*]}
# 取得数组单个元素的长度
lengthn=${#array_name[n]}
```



