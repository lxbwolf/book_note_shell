# 基础

命令解释器只关注脚本第一行里的#!, 后面再出现#!, 会被作为注释处理  
```bash
		  #!/bin/bash 
          echo "Part 1 of script." 
          a=1 
          #!/bin/bash 
          # 这将不会开始一个新脚本. 
          echo "Part 2 of script." 
```

###### 自删除脚本 

```bash
		 1 #!/bin/rm 
         2 # 自删除脚本. 
         3 
         4 # 当你运行这个脚本时,基本上什么都不会发生...除非这个文件消失不见. 
         5 
         6 WHATEVER=65 
         7 
         8 echo "This line will never print (betcha!)." 
         9 
        10 exit $WHATEVER  # 没关系,脚本是不会在这退出的.
```

###### /bin/more  

如果在一个README文件的开头加上`#!/bin/more`,并让它具有执行权限, 结果将是文档自动列出自己的内容(一个使用cat命令的here document可能是一个更好的选择).  

###### 命令分隔符  
`;` 分号 可以用来在一行中写多个命令  

###### 终止case选项  

`;;` 两个分号  

```bash
        1 case "$variable" in 
        2 abc)  echo "\$variable = abc" ;; 
        3 xyz)  echo "\$variable = xyz" ;; 
        4 esac
```

###### 逗号  

逗号连接了一系列的算术操作, 虽然里面所有的内容都运行了, 但只有最后一项被返回  

如:  
` let "t2=((a=9,15/3))"`  
等价于  
`set "a=9" and "t2=15/3"`  


