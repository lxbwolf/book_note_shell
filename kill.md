# kill  

该命令用于向某个工作（%jobnumber）或者是某个PID（数字）传送一个信号，它通常与ps和jobs命令一起使用，它的基本语法如下：  

```
kill -signal PID  ```

signal的常用参数如下：  
注：最前面的数字为信号的代号，使用时可以用代号代替相应的信号。  

```
1：SIGHUP，启动被终止的进程  
2：SIGINT，相当于输入ctrl+c，中断一个程序的进行  
9：SIGKILL，强制中断一个进程的进行  
15：SIGTERM，以正常的结束进程方式来终止进程  
17：SIGSTOP，相当于输入ctrl+z，暂停一个进程的进行  ```

例如:  
  

```
# 以正常的结束进程方式来终于第一个后台工作，可用jobs命令查看后台中的第一个工作进程  
kill -SIGTERM %1   
# 重新改动进程ID为PID的进程，PID可用ps命令通过管道命令加上grep命令进行筛选获得  
kill -SIGHUP PID  ```

