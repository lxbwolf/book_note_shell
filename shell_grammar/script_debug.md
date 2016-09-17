# 脚本调试

### 在shell脚本中输出调试信息  

通过在程序中加入调试语句把一些关键地方或出错的地方的相关信息显示出来是最常见的调试手段。Shell程序员通常使用echo语句输出信息，但仅仅依赖echo语句的输出跟踪信息很麻烦，调试阶段在脚本中加入的大量的echo语句在产品交付时还得再费力一一删除。 

#### 1 使用trap命令  

trap命令用于捕获指定的信号并执行预定义的命令。
其基本的语法是:  
`trap 'command' signal`  
其中signal是要捕获的信号，command是捕获到指定的信号之后，所要执行的命令。可以用kill –l命令看到系统中全部可用的信号名，捕获信号后所执行的命令可以是任何一条或多条合法的shell语句，也可以是一个函数名。  
shell脚本在执行时，会产生三个所谓的“伪信号”，(之所以称之为“伪信号”是因为这三个信号是由shell产生的，而其它的信号是由操作系统产生的)，通过使用trap命令捕获这三个“伪信号”并输出相关信息对调试非常有帮助。 

##### 表1 shell伪信号  

|信号名|产生时机|
|--|--|
|EXIT|从一个函数中退出或整个脚本执行完毕|
|ERR|当一条命令返回非零状态时(代表命令执行不成功)|
|DEBUG|脚本中每一条命令执行之前|

通过捕获EXIT信号,我们可以在shell脚本中止执行或从函数中退出时，输出某些想要跟踪的变量的值，并由此来判断脚本的执行状态以及出错原因,其使用方法是：
`trap 'command' EXIT`  
或  
`trap 'command' 0`  

通过捕获ERR信号,我们可以方便的追踪执行不成功的命令或函数，并输出相关的调试信息，以下是一个捕获ERR信号的示例程序，其中的$LINENO是一个shell的内置变量，代表shell脚本的当前行号。  

```bash
$ cat -n exp1.sh
     1  ERRTRAP()
     2  {
     3    echo "[LINE:$1] Error: Command or function exited with status $?"
     4  }
     5  foo()
     6  {
     7    return 1;
     8  }
     9  trap 'ERRTRAP $LINENO' ERR
    10  abc
    11  foo```  
    
输出结果:  

```bash
$ sh exp1.sh
exp1.sh: line 10: abc: command not found
[LINE:10] Error: Command or function exited with status 127
[LINE:11] Error: Command or function exited with status 1
```
      
在调试过程中，为了跟踪某些变量的值，我们常常需要在shell脚本的许多地方插入相同的echo语句来打印相关变量的值，这种做法显得烦琐而笨拙。而通过捕获DEBUG信号，我们只需要一条trap语句就可以完成对相关变量的全程跟踪。  

以下是一个通过捕获DEBUG信号来跟踪变量的示例程序:  

```bash
$ cat –n exp2.sh
     1  #!/bin/bash
     2  trap 'echo “before execute line:$LINENO, a=$a,b=$b,c=$c”' DEBUG
     3  a=1
     4  if [ "$a" -eq 1 ]
     5  then
     6     b=2
     7  else
     8     b=1
     9  fi
    10  c=3
    11  echo "end"```
    
输出结果:  

```bash
$ sh exp2.sh
before execute line:3, a=,b=,c=
before execute line:4, a=1,b=,c=
before execute line:6, a=1,b=,c=
before execute line:10, a=1,b=2,c=
before execute line:11, a=1,b=2,c=3
end```

从运行结果中可以清晰的看到每执行一条命令之后，相关变量的值的变化。同时，从运行结果中打印出来的行号来分析，可以看到整个脚本的执行轨迹，能够判断出哪些条件分支执行了，哪些条件分支没有执行。  

#### 2 使用tee命令  

在shell脚本中管道以及输入输出重定向使用得非常多，在管道的作用下，一些命令的执行结果直接成为了下一条命令的输入。如果我们发现由管道连接起来的一批命令的执行结果并非如预期的那样，就需要逐步检查各条命令的执行结果来判断问题出在哪儿，但因为使用了管道，这些中间结果并不会显示在屏幕上，给调试带来了困难，此时我们就可以借助于tee命令了。  
tee命令会从标准输入读取数据，将其内容输出到标准输出设备,同时又可将内容保存成文件。  
例如有如下的脚本片段，其作用是获取本机的ip地址：  
```bash
ipaddr=`/sbin/ifconfig | grep 'inet addr:' | grep -v '127.0.0.1'
| cut -d : -f3 | awk '{print $1}'` 
#注意=号后面的整句是用反引号(数字1键的左边那个键)括起来的。
echo $ipaddr```

运行这个脚本，实际输出的却不是本机的ip地址，而是广播地址,这时我们可以借助tee命令，输出某些中间结果，将上述脚本片段修改为：  
```bash
ipaddr=`/sbin/ifconfig | grep 'inet addr:' | grep -v '127.0.0.1'
| tee temp.txt | cut -d : -f3 | awk '{print $1}'`
echo $ipaddr```

之后，将这段脚本再执行一遍，然后查看temp.txt文件的内容：  

```bash
$ cat temp.txt
inet addr:192.168.0.1  Bcast:192.168.0.255  Mask:255.255.255.0```

我们可以发现中间结果的第二列(列之间以:号分隔)才包含了IP地址，而在上面的脚本中使用cut命令截取了第三列，故我们只需将脚本中的cut -d : -f3改为cut -d : -f2即可得到正确的结果。  
具体到上述的script例子，我们也许并不需要tee命令的帮助，比如我们可以分段执行由管道连接起来的各条命令并查看各命令的输出结果来诊断错误，但在一些复杂的shell脚本中，这些由管道连接起来的命令可能又依赖于脚本中定义的一些其它变量，这时我们想要在提示符下来分段运行各条命令就会非常麻烦了，简单地在管道之间插入一条tee命令来查看中间结果会更方便一些。  

#### 3 使用"调试钩子"  

在C语言程序中，我们经常使用DEBUG宏来控制是否要输出调试信息，在shell脚本中我们同样可以使用这样的机制，如下列代码所示：  

```bash
if [ “$DEBUG” = “true” ]; then
echo “debugging”  #此处可以输出调试信息
fi```

这样的代码块通常称之为“调试钩子”或“调试块”。在调试钩子内部可以输出任何您想输出的调试信息，使用调试钩子的好处是它是可以通过DEBUG变量来控制的，在脚本的开发调试阶段，可以先执行export DEBUG=true命令打开调试钩子，使其输出调试信息，而在把脚本交付使用时，也无需再费事把脚本中的调试语句一一删除。  
如果在每一处需要输出调试信息的地方均使用if语句来判断DEBUG变量的值，还是显得比较繁琐，通过定义一个DEBUG函数可以使植入调试钩子的过程更简洁方便，如下面代码所示:  

```bash
$ cat –n exp3.sh
     1  DEBUG()
     2  {
     3  if [ "$DEBUG" = "true" ]; then
     4      $@　　
     5  fi
     6  }
     7  a=1
     8  DEBUG echo "a=$a"
     9  if [ "$a" -eq 1 ]
    10  then
    11       b=2
    12  else
    13       b=1
    14  fi
    15  DEBUG echo "b=$b"
    16  c=3
    17  DEBUG echo "c=$c"```
    

在上面所示的DEBUG函数中，会执行任何传给它的命令，并且这个执行过程是可以通过DEBUG变量的值来控制的，我们可以把所有跟调试有关的命令都作为DEBUG函数的参数来调用，非常的方便。   

### 使用shell的执行选项  

调试手段是通过修改shell脚本的源代码，令其输出相关的调试信息来定位错误的，那有没有不修改源代码来调试shell脚本的方法呢？答案就是使用shell的执行选项  

* -n 只读取shell脚本，但不实际执行
* -x 进入跟踪方式，显示所执行的每一条命令
* -c "string" 从strings中读取命令

“-n”可用于测试shell脚本是否存在语法错误，但不会实际执行命令。在shell脚本编写完成之后，实际执行之前，首先使用“-n”选项来测试脚本是否存在语法错误是一个很好的习惯。因为某些shell脚本在执行时会对系统环境产生影响，比如生成或移动文件等，如果在实际执行才发现语法错误，您不得不手工做一些系统环境的恢复工作才能继续测试这个脚本。  

“-c”选项使shell解释器从一个字符串中而不是从一个文件中读取并执行shell命令。当需要临时测试一小段脚本的执行结果时，可以使用这个选项，如下所示：  
`sh -c 'a=1;b=2;let c=$a+$b;echo "c=$c"'`  

"-x"选项可用来跟踪脚本的执行，是调试shell脚本的强有力工具。“-x”选项使shell在执行脚本的过程中把它实际执行的每一个命令行显示出来，并且在行首显示一个"+"号。 "+"号后面显示的是经过了变量替换之后的命令行的内容，有助于分析实际执行的是什么命令。 “-x”选项使用起来简单方便，可以轻松对付大多数的shell调试任务,应把其当作首选的调试手段。  

把`trap ‘command’ DEBUG`机制与“-x”选项结合起来:  
```bash
$ sh –x exp2.sh
+ trap 'echo "before execute line:$LINENO, a=$a,b=$b,c=$c"' DEBUG
++ echo 'before execute line:3, a=,b=,c='
before execute line:3, a=,b=,c=
+ a=1
++ echo 'before execute line:4, a=1,b=,c='
before execute line:4, a=1,b=,c=
+ '[' 1 -eq 1 ']'
++ echo 'before execute line:6, a=1,b=,c='
before execute line:6, a=1,b=,c=
+ b=2
++ echo 'before execute line:10, a=1,b=2,c='
before execute line:10, a=1,b=2,c=
+ c=3
++ echo 'before execute line:11, a=1,b=2,c=3'
before execute line:11, a=1,b=2,c=3
+ echo end
end```

在上面的结果中，前面有“+”号的行是shell脚本实际执行的命令，前面有“++”号的行是执行trap机制中指定的命令，其它的行则是输出信息。  

shell的执行选项除了可以在启动shell时指定外，亦可在脚本中用set命令来指定。 "set -参数"表示启用某选项，"set +参数"表示关闭某选项。有时候我们并不需要在启动时用"-x"选项来跟踪所有的命令行，这时我们可以在脚本中使用set命令，如以下脚本片段所示：  

```bash
set -x　　　 #启动"-x"选项 
要跟踪的程序段 
set +x　　　　 #关闭"-x"选项```

set命令同样可以使用上一节中介绍的调试钩子—DEBUG函数来调用，这样可以避免脚本交付使用时删除这些调试语句的麻烦，如以下脚本片段所示：  

```bash
DEBUG set -x　　　 #启动"-x"选项 
要跟踪的程序段 
DEBUG set +x　　　 #关闭"-x"选项```

### 对"-x"选项的增强  

"-x"执行选项是目前最常用的跟踪和调试shell脚本的手段，但其输出的调试信息仅限于进行变量替换之后的每一条实际执行的命令以及行首的一个"+"号提示符，居然连行号这样的重要信息都没有，对于复杂的shell脚本的调试来说，还是非常的不方便。幸运的是，我们可以巧妙地利用shell内置的一些环境变量来增强"-x"选项的输出信息，下面先介绍几个shell内置的环境变量：  
$LINENO  
代表shell脚本的当前行号，类似于C语言中的内置宏`__LINE__`  
$FUNCNAME  
函数的名字，类似于C语言中的内置宏__func__,但宏__func__只能代表当前所在的函数名，而$FUNCNAME的功能更强大，它是一个数组变量，其中包含了整个调用链上所有的函数的名字，故变量${FUNCNAME[0]}代表shell脚本当前正在执行的函数的名字，而变量${FUNCNAME[1]}则代表调用函数${FUNCNAME[0]}的函数的名字，余者可以依此类推。
