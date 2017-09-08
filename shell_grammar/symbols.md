# 符号

1 冒号(:) 是一个空命令. 作用与true相同. ":"是一个bash内建命令, 返回值为0, 即与true相同. 例:

```bash
:
echo $?  # 0
```

死循环

```bash
while :
do
    list_1
    list_2
done
```

if/then 中的占位符

```bash
if list
then : # 什么都不做, 引出分支
else
    take-some-action
fi
```

在一个2元命令中, 提供一个占位符, 表明后面的表达式, 不是一个命令, 如

```bash
:$((n=$n+1)
```

如果没有:, bash会尝试把"$((n=$n+1))" 解释成一个命令

使用"参数替换" 来评估字符串变量

```bash
:${HOSTNAME?}${USER?}${MAIL?}
# 如果一个或多个环境变量没有设置, 则打印错误信息
```

在和>(重定向符号)结合使用时, 把一个文件截断到0长度, 不修改它的权限. 如果文件不存在, 则创建它

```bash
: > data.xxx # 文件"data.xxx" 被清空
# 与 cat /dev/null > data.xxx 作用相同, 但是不会产生一个新的进程, 因为:是一个内建命令.
```
只适用于普通文件, 不适用于管道, 符号链接, 和其他特殊文件.

也可以用作注释, :与#不同的是, :不会关闭剩余行的错误检查.

2 Shell脚本中, "history mechanism" 是被禁止的 
3 `*` 是乘法运算, `**`是幂运算
4 ? 问号.  在"参数替换" 中测试一个变量是否被set了, 在file globbing 中和正则表示式一样, 用于匹配任意的单个字符.

5 命令组和代码块

() 命令组. 如
`(a=hello,echo $a)`
在()中的命令列表, 将作为一个子Shell来运行
在()中的变量, 由于是在子Shell总运行的, 因此对脚本剩下的部分是不可见的

如
```bash
a=123
(a=321;)
echo "a=$a" # a=123
# 在()中的a变量, 更像是一个局部变量
```

{} 代码块, 又称内部组. 这个结构创建了一个匿名的函数, 与函数不同的是, 在{}中声明的变量, 对于脚本剩余的代码是可见的, 如
```bash
{
	local a;
	a=123;
}
# bash中的local申请的变量只能用在函数中
```

```bash
a=123;
{a=321;}
echo "a=$a" # a=321
```

()也可用作初始化数组
array=(element1,element2,element3)

{xxx,yyy,zzz} 大括号扩展, 例

```bash
cat {file1,file2,file3} > combined_file
# 把file1 file2 file3连接在一起, 重定向到combined_file
```

```bash
cp file1.{txt,bak}
# 把file1.txt 复制到file1.bak
```

一个命令会对大括号中以逗号分隔的文件列表起作用, file globbing会对大括号中的文件名作扩展
```bash
# 大括号中不允许有空白, 除非这个空白是有意义的
echo {file1,file2}\ :{\ A," B",' C'}
# file1 : A file1 : B file1 : C file2 : A file2 : B file2 : C
```

6 其他

```
“ ” 允许转义、引用

‘ ’ 禁止转义、引用

` ` 替换里面命令输出 例如for i in`seq 1 99`: 可以执行从1数到99的命令

$( ) 和 ` `一样 都是非常常用的命令```  

$? 输出0为正常 非0为异常

$0 输出命令本身 $1-9 为第几个输入参数 $* 所有输入参数 $# 输入参数的个数

$[ ] 计算 但不输出 例如$[ 1+2 ]其实就是3

expr 计算并且输出  
