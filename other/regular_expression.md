
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

##### `.` 匹配除换行符外的任意一个字符

`grep “s..d” test_rule.txt`

匹配s和d直接一定要有两个字符的行

```bash
# grep "s..d" test_rule.txt
Mr. Li Ming said:
Later, Mr. Li Ming soid his hot body.
```

`grep “s.*d” test_rule.txt`

匹配s和d直接任意字符

```bash
# grep "s.*d" test_rule.txt
Mr. Li Ming said:
he never saaaid those words
Later, Mr. Li Ming soid his hot body.
```

`grep “.*” test_rule.txt`
匹配所有内容

```bash
# grep ".*" test_rule.txt
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

##### 3 `^` 匹配行首 `$` 匹配行尾

`grep “^M” test_rule.txt`

匹配以大写M开头的行

```bash
# grep "^M" test_rule.txt
Mr. Li Ming said:
Mr. Shen Chao is the most honest man
```

`grep “n$” test_rule.txt`

匹配以小写n结尾的行

```bash
# grep "n$" test_rule.txt
Mr. Shen Chao is the most honest man
```

`grep -n “^$” test_rule.txt`

匹配空白行

```bash
# grep -n "^$" test_rule.txt
4:
8:
11:
```

##### 4 `[]` 匹配括号中指定的任意一个字符, 只匹配一个字符

`grep “s[ao]id” test_rule.txt`

匹配s和i字母之间，要么是a，要么是o的行

```bash
# grep "s[ao]id" test_rule.txt
Mr. Li Ming said:
Later, Mr. Li Ming soid his hot body.
```

`grep “[0-9]” test_rule.txt`

匹配任意一个数字

```bash
# grep "[0-9]" test_rule.txt
123despise him.
5555 nice
```

`grep “^[a-z]” test_rule.txt`

匹配用小写字母开头的行

```bash
# grep "^[a-z]" test_rule.txt
he was the honest man in LampBrother.
he never saaaid those words
because, actuaaaally,
```

##### 5 `[^]` 匹配除括号中以外的任意一个字符

`grep “^[^a-z]” test_rule.txt`

匹配不用小写字母开头的行

```bash
# grep "^[^a-z]" test_rule.txt
Mr. Li Ming said:
123despise him.
But since Mr. Shen Chao came,
5555 nice
Mr. Shen Chao is the most honest man
Later, Mr. Li Ming soid his hot body.
```

`grep “^[^a-zA-Z]” test_rule.txt`

匹配不用字符开头的行

```bash
# grep "^[^a-zA-Z]" test_rule.txt
123despise him.
5555 nice
```

##### 6 `\` 转义符

`grep “\.$” test_rule.txt`

匹配以.结尾的行

```bash
# grep "\.$" test_rule.txt
he was the honest man in LampBrother.
123despise him.
Later, Mr. Li Ming soid his hot body.
```

##### 7 `\{n\}` 表示其前面的字符恰好出现n次

`grep “a\{3\}” test_rule.txt`

匹配字母a连续出现3次的行

```bash
# grep "a\{3\}" test_rule.txt
he never saaaid those words
because, actuaaaally,
```

`grep “[0-9]\{3\}” test_rule.txt`

匹配包含连续3个数字的行

```bash
# grep "[0-9]\{3\}" test_rule.txt
123despise him.
5555 nice
```

##### 8 `\{n,\}`表示其前面的字符出现不小于n次

`grep “^[0-9]\{3,\}” test_rule.txt`

匹配至少连续3个数字开头的行

```bash
# grep "^[0-9]\{3,\}" test_rule.txt
123despise him.
5555 nice
```

##### 9 `\{n,m\}` 表示其前面的字符出现不小于n次，最多m次

`grep “sa\{1,3\}i” test_rule.txt`

匹配s和i之间最少1个a，最多3个a

```bash
# grep "as\{1,3\}i" test_rule.txt
Mr. Li Ming said:
he never saaaid those words
```