
##### 正则表达式和通配符

1 正则表达式是用在文件中匹配符合条件的字符串，正则是包含匹配，grep，awk，sed等命令可以支持正则表达式  
2 通配符是用来匹配符合条件的文件名，通配符是完全匹配，ls，find，cp这些命令不支持正则表达式，所以只能用Shell自己的通配符来进行匹配了。

##### 测试文件

```bash
# cat testrule.txt
Mr. Li Ming said:
he was the honest man in LampBrother.
123despise him.

But since Mr. Shen Chao came,
he never saaaid those words
5555 nice

because, actuaaaally,
Mr. Shen Chao is the most honest man

Later, Mr. Li Ming soid his hot body.
```

##### 1 `*`前一个字符匹配0次或多次

`grep “a*” test_rule.txt`

匹配所有内容，包括空白行（由于`*`可以匹配0次）

```bash
# grep “a*” test_rule.txt
Mr. Li Ming said:
he was the honest man in LampBrother.
123despise him.

But since Mr. Shen Chao came,
he never saaaid those words
5555 nice

because, actuaaaally,
Mr. Shen Chao is the most honest man

Later, Mr. Li Ming soid his hot body.
```

`grep “aa*” test_rule.txt`

匹配至少包含有一个a的行

```bash
# grep “aa*” test_rule.txt
Mr. Li Ming said:
he was the honest man in LampBrother.
But since Mr. Shen Chao came,
he never saaaid those words
because, actuaaaally,
Mr. Shen Chao is the most honest man
Later, Mr. Li Ming soid his hot body.
```

`grep “aaa*” test_rule.txt`

匹配至少包含有两个a的行

```bash
# grep “aaa*” test_rule.txt
he never saaaid those words
because, actuaaaally,
```

