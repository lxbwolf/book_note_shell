# 条件测试

test 和 [  
命令test或[可以测试一个条件是否成立，如果测试结果为真，则该命令的Exit Status为0，如果测试结果为假，则命令的Exit Status为1（注意与C语言的逻辑表示正好相反）。例如测试两个数的大小关系：  
```
$ VAR=2
$ test $VAR -gt 1
$ echo $?
0
$ test $VAR -gt 3
$ echo $?
1
$ [ $VAR -gt 3 ]
$ echo $?
1```

虽然看起来很奇怪，但左方括号[确实是一个命令的名字，传给命令的各参数之间应该用空格隔开，比如，$VAR、-gt、3、]是[命令的四个参数，它们之间必须用空格隔开。命令test或[的参数形式是相同的，只不过test命令不需要]参数。  

| 条件 | 解释 |
| -- | -- |
|[ -d DIR ] |	如果DIR存在并且是一个目录则为真 |
| [ -f FILE ] | 如果FILE存在且是一个普通文件则为真 |
| [ -z STRING ] |如果STRING的长度为零则为真 |
| [ -n STRING ] |如果STRING的长度非零则为真 |
|[ STRING1 = STRING2 ] | 如果两个字符串相同则为真 |
|[ STRING1 != STRING2 ]|如果字符串不相同则为真 |

和C语言类似，测试条件之间还可以做与、或、非逻辑运算：  

| 条件 | 解释 |
| -- | -- |
|[ ! EXPR ] | EXPR可以是上表中的任意一种测试条件，!表示逻辑反|
| [ EXPR1 -a EXPR2 ]|	EXPR1和EXPR2可以是上表中的任意一种测试条件，-a表示逻辑与 |
| [ EXPR1 -o EXPR2 ]|	EXPR1和EXPR2可以是上表中的任意一种测试条件，-o表示逻辑或 |


实例:  
```
$ VAR=abc
$ [ -d Desktop -a $VAR = 'abc' ]
$ echo $?
0```

注意，如果上例中的$VAR变量事先没有定义，则被Shell展开为空字符串，会造成测试条件的语法错误（展开为[ -d Desktop -a = 'abc' ]），作为一种好的Shell编程习惯，应该总是把变量取值放在双引号之中（展开为[ -d Desktop -a "" = 'abc' ]）：  
```
$ unset VAR
$ [ -d Desktop -a $VAR = 'abc' ]
bash: [: too many arguments
$ [ -d Desktop -a "$VAR" = 'abc' ]
$ echo $?
1```
