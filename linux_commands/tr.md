# tr

tr命令可以对来自标准输入的字符进行替换, 压缩和删除. 它可以将一组字符变成另一组.

**语法**

```
tr (options) (args)
```

**选项**

```
-c --complerment: 补集
-d --delete: 删除
-s --squeeze-repeats: 把连续重复的字符以单独一个字符表示
-t --truncate-set1: 删除第一个字符集较第二个字符集多出的字符
```

**示例**

将输入字符由小写转为大写

```
echo "hello world" | tr 'a-z' 'A-Z'
HELLO WORLD
```

'a-z'和'A-Z'或者\(\[a-z\]和\[A-Z\]\)都是集合, 集合可以自己制定. 例如: 'ABD-}'  'bB.,'  'a-de-h'  'a-c0-9' 都是集合, 集合里可以只用'\n' '\t' 或其他ASCII字符.

删除字符

```
ehco "hello 123 world 456" | tr -d '0-9'
hello world
```

将制表符转为空格

```
cat text | tr '\t' ' '
```

字符集补集, 从输入文本中将补集中的所有字符删除

```
echo aa.,a 1 b#$bb 2 c*/cc 3 ddd 4 | tr -d -c '0-9 \n'
```

此例中, 删除除0-9, 空格和换行符\n外的所有字符

压缩输入中重复的字符

```
echo "thisssssss is       a text linnnnnnnnnne." | tr -s ' sn'
this is a text line.
```

**tr可以使用的字符类**

```
[:alnum:] 字母和数字
[:alpha:] 字母
[:cntrl:] 控制(非打印)字符
[:digit:] 数字
[:graph:] 图形字符
[:lower:] 小写字母
[:print:] 可打印字符
[:punct:] 标点符号
[:space:] 空白字符
[:upper:] 大写字母
[:xdigit:] 十六进制字符
```



