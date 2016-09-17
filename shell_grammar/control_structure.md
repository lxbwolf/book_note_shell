# 控制结构

 1 shell的布尔判断命令([]或test). test的三种类型: 字符串比较, 算数比较和文件有关的条件测试.  
  2 控制结构  
  
  if 语句  
  ```
  if condition
  then
      statements
  else
      statements
  fi
  ```
例:  
```
#!/bin/sh

    if [ -f /root/cherie_test/test_path.sh ];then
       echo "/root/cherie_test/test_path.sh exists"
    fi
   
    if [ -d /root/cherie_test/test_path.sh ];then
       echo "/root/cherie_test/test_path.sh is a director"
   else
      echo "/root/cherie_test/test_path.sh  is not a directory"
   fi   ```

[ ]前后都要有空格，不然会报[: missing `]'错误；if与[之间也需要有空格，没有的话会报syntax error near unexpected token `then'错误。  

elif 语句  
```
#!/bin/sh

         echo "Is it morning? Please answer yes or no "
         read timeofday

         if[ $timeofday = "yes"]; then
            echo "Good morning"
            exit 0
         elif [ $timeofday = "no" ];then
            echo "Good afternoon"
            exit 0
         else
            echo "Sorry,$timeofday not recognized. Enter yes or no "
            exit 1 //异常退出
        fi```
        
解析：elif会对在第一个if条件不满足的情况下进行进一步测试，如果两次测试的结果都不成功，就打印出一条错误信息并以1为退出码退出  

for 语句  

语法:  
```
for variable in values
do
    Statements
done```

例:  
```
#!/bin/sh

for file in $(ls f*.sh); do
        lpr $file
done
exit0```

解析：打印当前目录中所有以字母f开头的脚本文件。for的参数来着$()中的命令的输出结果，shell扩展f*.sh给出所有匹配此模式的文件的名字。此例中可能会报错lpr: error - scheduler not responding!这是vim配置问题。  

while语句  

语法:  
```
while condition do
     Statements
Done```

例:  
```
#!/bin/sh

   foo=1
   whlie [ "$foo" -le 20 ]
   do 
      echo "Here we go again"
      foo=$(($foo+1))
   done
   exit 0```
   
case语句  

语法:  
```
case variable in
  pattern) 
      statements
      ;;
  pattern)
      statements
      ;;
  ...
esac ```

例:  
```
#！/bin/sh

    echo "Is it morning?Please answer yes or no"
    read timeofday
    case "$timeofday" in
         yes|y|Yes|YES) 
                  echo "Good morning"
                  echo  "Up bright and early this morning"
                   ;;
         n*|N*) 
                  echo "Good afternoon";;
         *)   
                  echo "Sorry ,answer not recognized";;
    esac```
    
    
   
