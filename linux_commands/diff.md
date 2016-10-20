# diff
    the diff command displays the only line that differs between the two files
        diff is prescriptive, describing what changes need to be made to the first file to make it the
        same as the second file.
    you can use diff3 command to look at differences between three files.
Usage: diff [OPTION] file1 file2 
Usage: diff3 [OPTION] file1 file2 file3

diff 的选项由 "-" 开始所以正常地 源文件（名） 和 目标文件（名） 不可以用 "-" 开头。
如果 源文件 和 目标文件 都是目录, diff 比较两个目录中相应的文件，依照字母次序排序；这个比较是不会递归的，除非给出 -r 或者 --recursive.


## 参数：


-a，--text 所有的文件视为文本文件进行逐行比较  
-b 忽略空格  
-B，--ignore-blank-lines 忽略插入/删除空行  
-H, --speed-large-files 比较大文件时,可加快速度  
-i, --ignore-case 忽略大小写  
-p 若比较的文件为C语言的程序码文件,则显示差异的函数名称  
-n, --rcs 将比较结果以rcs的格式显示  
-q, --brief 仅报告是否存在差异  
-r, --recursive 比较目录时，递归子目录  
-w, --ignore-all-space 比较行时忽略全部空格  
-y, --side-by-side 　以并列的方式显示文件的异同之处  

## 实例


### 实例1 比较两个文件


```
[root@localhost test3]# diff log2014.log log2013.log 
3c3  
< 2014-03  
---  
> 2013-03
8c8  
< 2013-07  
---  
> 2013-08  
11,12d10  
< 2013-11  
< 2013-12  ```
  
  
**说明：**  
上面的“3c3”和“8c8”表示log2014.log和log20143log文件在3行和第8行内容有所不同；"11,12d10"表示第一个文件比第二个文件多了第11和12行。  
diff 的normal 显示格式有三种提示:  
a - add  
c - change  
d - delete   
  
  
### 实例2 并排格式输出  

```
[root@localhost test3]# diff log2014.log log2013.log  -y -W 50
2013-01                 2013-01
2013-02                 2013-02
2014-03               | 2013-03
2013-04                 2013-04
2013-05                 2013-05
2013-06                 2013-06
2013-07                 2013-07
2013-07               | 2013-08
2013-09                 2013-09
2013-10                 2013-10
2013-11               <
2013-12               <
[root@localhost test3]# diff log2013.log log2014.log  -y -W 50
2013-01                 2013-01
2013-02                 2013-02
2013-03               | 2014-03
2013-04                 2013-04
2013-05                 2013-05
2013-06                 2013-06
2013-07                 2013-07
2013-08               | 2013-07
2013-09                 2013-09
2013-10                 2013-10
                      > 2013-11
                      > 2013-12```
  
  
**说明：**  
“|”表示前后2个文件内容有不同  
“<”表示后面文件比前面文件少了1行内容  
“>”表示后面文件比前面文件多了1行内容  


### 实例3 上下文格式输出  


```
[root@localhost test3]# diff log2013.log log2014.log  -c
*** log2013.log 2012-12-07 16:36:26.000000000 +0800
--- log2014.log 2012-12-07 18:01:54.000000000 +0800
***************
*** 1,10 ****
  2013-01
  2013-02
! 2013-03
  2013-04
  2013-05
  2013-06
  2013-07
! 2013-08
  2013-09
  2013-10
--- 1,12 ----
  2013-01
  2013-02
! 2014-03
  2013-04
  2013-05
  2013-06
  2013-07
! 2013-07
  2013-09
  2013-10
+ 2013-11
+ 2013-12[root@localhost test3]# diff log2014.log log2013.log  -c
*** log2014.log 2012-12-07 18:01:54.000000000 +0800
--- log2013.log 2012-12-07 16:36:26.000000000 +0800
***************
*** 1,12 ****
  2013-01
  2013-02
! 2014-03
  2013-04
  2013-05
  2013-06
  2013-07
! 2013-07
  2013-09
  2013-10
- 2013-11
- 2013-12
--- 1,10 ----
  2013-01
  2013-02
! 2013-03
  2013-04
  2013-05
  2013-06
  2013-07
! 2013-08
  2013-09
  2013-10
  [root@localhost test3]#```
  
  
**说明：**  
这种方式在开头两行作了比较文件的说明，这里有三中特殊字符：  
“＋” 比较的文件的后者比前着多一行  
“－” 比较的文件的后者比前着少一行  
“！” 比较的文件两者有差别的行  
  
### 实例4 统一格式输出

```
[root@localhost test3]# diff log2014.log log2013.log  -u
--- log2014.log 2012-12-07 18:01:54.000000000 +0800
+++ log2013.log 2012-12-07 16:36:26.000000000 +0800
@@ -1,12 +1,10 @@
 2013-01
 2013-02
-2014-03
+2013-03
 2013-04
 2013-05
 2013-06
 2013-07
-2013-07
+2013-08
 2013-09
 2013-10
-2013-11
-2013-12```
  
**说明：**  
它的第一部分，也是文件的基本信息：  
--- log2014.log 2012-12-07 18:01:54.000000000 +0800  
+++ log2013.log 2012-12-07 16:36:26.000000000 +0800  
"---"表示变动前的文件，"+++"表示变动后的文件。  
第二部分，变动的位置用两个@作为起首和结束。  
　　	@@ -1,12 +1,10 @@  
前面的"-1,12"分成三个部分：减号表示第一个文件（即log2014.log），"1"表示第1行，"12"表示连续12行。合在一起，就表示下面是第一个文件从第1行开始的连续12行。同样的，"+1,10"表示变动后，成为第二个文件从第1行开始的连续10行。










