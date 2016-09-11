# sed  

[sed参考手册](http://www.gnu.org/software/sed/manual/sed.html)  
sed全名为stream editor, 流编辑器, 用程序的方式来编辑文本.   
#### 参数  



#### 用s命令替换  

原文:  
```language
$ cat pets.txt
This is my cat
  my cat's name is betty
This is my dog
  my dog's name is frank
This is my fish
  my fish's name is george
This is my goat
  my goat's name is adam
```

把其中的my字符串替换成Hao Chen’s，(表示替换命令，/my/表示匹配my，/Hao Chen’s/表示把匹配替换成Hao Chen’s，/g 表示一行上的替换所有的匹配)：  

```bash
$ sed "s/my/Hao Chen's/g" pets.txt
This is Hao Chen's cat
  Hao Chen's cat's name is betty
This is Hao Chen's dog
  Hao Chen's dog's name is frank
This is Hao Chen's fish
  Hao Chen's fish's name is george
This is Hao Chen's goat
  Hao Chen's goat's name is adam
```
如果使用单引号,则特殊字符不需要转义(反斜杠"\");  

上面的例子并没有改变原来的文件, 只是把处理的结果输出, 如果希望把结果写回文件, 可以用 "i" 参数:  

`$ sed -i "s/my/Hao Chen's/g" pets.txt`  

在每行最前面加点东西:  
```bash
$ sed 's/^/#/g' pets.txt
#This is my cat
#  my cat's name is betty
#This is my dog
#  my dog's name is frank
#This is my fish
#  my fish's name is george
#This is my goat
#  my goat's name is adam
```
在每行最后边加点东西:  
```bash
$ sed 's/$/ --- /g' pets.txt
This is my cat ---
  my cat's name is betty ---
This is my dog ---
  my dog's name is frank ---
This is my fish ---
  my fish's name is george ---
This is my goat ---
  my goat's name is adam ---
```

去表某html中的tags:  

```bash
$ cat html.txt
  <b>This</b> is what <span style="text-decoration: underline;">I</span> meant. Understand?
  
  # 如果你这样搞的话，就会有问题
$ sed 's/<.*>//g' html.txt
 Understand?
# 要解决上面的那个问题，就得像下面这样。
# 其中的'[^>]' 指定了除了>的字符重复0次或多次。
$ sed 's/<[^>]*>//g' html.txt
This is what I meant. Understand?
```

指定替换的行号和行数:  

```bash
$ sed "3s/my/your/g" pets.txt
This is my cat
  my cat's name is betty
This is your dog
  my dog's name is frank
This is my fish
  my fish's name is george
This is my goat
  my goat's name is adam
  
  $ sed "3,6s/my/your/g" pets.txt
This is my cat
  my cat's name is betty
This is your dog
  your dog's name is frank
This is your fish
  your fish's name is george
This is my goat
  my goat's name is adam
```

把每一行的第一个s替换为S:  

```bash
$ sed 's/s/S/1' my.txt
ThiS is my cat, my cat's name is betty
ThiS is my dog, my dog's name is frank
ThiS is my fish, my fish's name is george
ThiS is my goat, my goat's name is adam
```

把每一行第二个s替换为S:  

```bash
$ sed 's/s/S/2' my.txt
This iS my cat, my cat's name is betty
This iS my dog, my dog's name is frank
This iS my fish, my fish's name is george
This iS my goat, my goat's name is adam
```

替换每一行第三个以后的s:  

```bash
$ sed 's/s/S/3g' my.txt
This is my cat, my cat'S name iS betty
This is my dog, my dog'S name iS frank
This is my fiSh, my fiSh'S name iS george
This is my goat, my goat'S name iS adam
```

#### 多个匹配  

如果我们需要一次替换多个模式，可参看下面的示例：（第一个模式把第一行到第三行的my替换成your，第二个则把第3行以后的This替换成了That）  

```bash
$ sed '1,3s/my/your/g; 3,$s/This/That/g' my.txt
This is your cat, your cat's name is betty
This is your dog, your dog's name is frank
That is your fish, your fish's name is george
That is my goat, my goat's name is adam
```language
```
上面的命令等价于：（注：下面使用的是sed的-e命令行参数）
`sed -e '1,3s/my/your/g' -e '3,$s/This/That/g' my.txt`

可以使用&来当做被匹配的变量, 在它的左右加点东西:  

```bash
$ sed 's/my/[&]/g' my.txt
This is [my] cat, [my] cat's name is betty
This is [my] dog, [my] dog's name is frank
This is [my] fish, [my] fish's name is george
This is [my] goat, [my] goat's name is adam
```

#### 圆括号匹配  

使用圆括号匹配的示例：（圆括号括起来的正则表达式所匹配的字符串会可以当成变量来使用，sed中使用的是\1,\2…）  

```bash
$ sed "s/This is my \([^,]*\),.*is \(.*\)/\1:\2/g" my.txt
cat:betty
dog:frank
fish:george
goat:adam
```

