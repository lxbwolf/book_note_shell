# find


## 1 name选项  
可以使用某种文件名模式来匹配文件，记住要用引号将文件名模式引起来  
*find . -name "*.log" -print*  

想要的当前目录及子目录中查找文件名以一个大写字母开头的文件，可以用  
find . -name "[A-Z]*" -print  

如果想在当前目录查找文件名以一个个小写字母开头，最后是4到9加上.log结束的文件:  
find . -name "[a-z]*[4-9].log" -print  



## 2 perm选项  

按文件权限模式来查找文件的话。最好使用八进制的权限表示法  

```
[root@localhost test]# find . -perm 755 -print
.
./scf
./scf/lib
./scf/service
./scf/service/deploy
./scf/service/deploy/product
./scf/service/deploy/info
./scf/doc
./scf/bin
[root@localhost test]#```


## 3 user和nouser选项  

find . -user username -print  

为了查找属主帐户已经被删除的文件，可以使用-nouser选项。在/home目录下查找所有的这类文件  
find . -nouser -print  


##  4 group和nogroup选项  

find . -group groupname -print  

要查找没有有效所属用户组的所有文件  
find . -nogroup -print  


## 5 按照更改时间或访问时间查找文件 

如果希望按照更改时间来查找文件，可以使用mtime,atime或ctime选项。如果系统突然没有可用空间了，很有可能某一个文件的长度在此期间增长迅速，这时就可以用mtime选项来查找这样的文件。    

用减号-来限定更改时间在距今n日以内的文件，而用加号+来限定更改时间在距今n日以前的文件  

希望在系统根目录下查找更改时间在5日以内的文件，可以用：  
find / -mtime -5 -print  
为了在/var/adm目录下查找更改时间在3日以前的文件，可以用:  
find /var/adm -mtime +3 -print  


## 6 查找比某个文件新或旧的文件  

如果希望查找更改时间比某个文件新但比另一个文件旧的所有文件，可以使用-newer选项。
它的一般形式为：  
newest_file_name ! oldest_file_name  
其中，！是逻辑非符号。    


### 实例1 查找更改时间比文件log2012.log新但比文件log2017.log旧的文件  

```
[root@localhost test]# ll
总计 316
-rw-r--r-- 1 root root 302108 11-13 06:03 log2012.log
-rw-r--r-- 1 root root     61 11-13 06:03 log2013.log
-rw-r--r-- 1 root root      0 11-13 06:03 log2014.log
-rw-r--r-- 1 root root      0 11-13 06:06 log2015.log
-rw-r--r-- 1 root root      0 11-16 14:41 log2016.log
-rw-r--r-- 1 root root      0 11-16 14:43 log2017.log
drwxr-xr-x 6 root root   4096 10-27 01:58 scf
drwxrwxr-x 2 root root   4096 11-13 06:08 test3
drwxrwxr-x 2 root root   4096 11-13 05:50 test4
[root@localhost test]# find -newer log2012.log ! -newer log2017.log
.
./log2015.log
./log2017.log
./log2016.log
./test3
[root@localhost test]#```


### 实例2 查找更改时间在比log2012.log文件新的文件  

```
[root@localhost test]# find -newer log2012.log
.
./log2015.log
./log2017.log
./log2016.log
./test3
[root@localhost test]#```


## 7 type选项  

查找所有目录  
find . -type d -print  

查找除目录以外类型的文件  
find . ! -type d -print  

查找所有符号链接文件  
find . -type l -print  






















