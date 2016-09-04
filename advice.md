# advice

GitBook allows you to organize your book into chapters, each chapter is stored in a separate file like this one.  

### 添加脚本描述头  

```
#!/bin/bash
### Description: Adds users based on provided CSV file 
### CSV file must use : as separator
### uid:username:comment:group:addgroups:/home/dir:/usr/shell:passwdage:password
### Written by: Benjamin Cane - ben@example.com on 03-2012```  

为什么要添加这些内容？很简单。这里的描述是为了向阅读该脚本的人解释脚本用途并提供他们需要了解的其他信息。添加名字和邮箱，阅读该脚本的人如果有疑问就可以联系上我并提问。添加日期，当他们阅读脚本时，至少知道该脚本是多久之前编写的。日期还能触动你的怀旧之情，当发现自己很久前编写的脚本时，你会问问自己“在编写该脚本时，我是怎么想的？”。

脚本中的描述头可以根据自己的想法随意定制，没有硬性规定哪些是必须的，哪些不需要。通常只要保证信息有效并且放置在脚本开头即可。  

### 缩进代码  

代码可读性非常重要，但很多人都会忽略这一点。在深入了解缩进为何很重要前，我们来看一个例子：  

```
NEW_UID=$(echo $x | cut -d: -f1)
NEW_USER=$(echo $x | cut -d: -f2)
NEW_COMMENT=$(echo $x | cut -d: -f3)
NEW_GROUP=$(echo $x | cut -d: -f4)
NEW_ADDGROUP=$(echo $x | cut -d: -f5)
NEW_HOMEDIR=$(echo $x | cut -d: -f6)
NEW_SHELL=$(echo $x | cut -d: -f7)
NEW_CHAGE=$(echo $x | cut -d: -f8)
NEW_PASS=$(echo $x | cut -d: -f9)    
PASSCHK=$(grep -c ":$NEW_UID:" /etc/passwd)
if [ $PASSCHK -ge 1 ]
then
echo "UID: $NEW_UID seems to exist check /etc/passwd"
else
useradd -u $NEW_UID -c "$NEW_COMMENT" -md $NEW_HOMEDIR -s $NEW_SHELL -g $NEW_GROUP -G $NEW_ADDGROUP $NEW_USER
if [ ! -z $NEW_PASS ]
then
echo $NEW_PASS | passwd --stdin $NEW_USER
chage -M $NEW_CHAGE $NEW_USER
chage -d 0 $NEW_USER 
fi
fi```

上述代码能工作吗？是的，但这段代码写的并不好，如果这是一个500行bash脚本，没有任何缩进，那么理解该脚本的用途将非常困难。下面看一下使用缩进后的同一段代码：  

```
NEW_UID=$(echo $x | cut -d: -f1)
NEW_USER=$(echo $x | cut -d: -f2)
NEW_COMMENT=$(echo $x | cut -d: -f3)
NEW_GROUP=$(echo $x | cut -d: -f4)
NEW_ADDGROUP=$(echo $x | cut -d: -f5)
NEW_HOMEDIR=$(echo $x | cut -d: -f6)
NEW_SHELL=$(echo $x | cut -d: -f7)
NEW_CHAGE=$(echo $x | cut -d: -f8)
NEW_PASS=$(echo $x | cut -d: -f9)
 
PASSCHK=$(grep -c ":$NEW_UID:" /etc/passwd)
if [ $PASSCHK -ge 1 ]
then
  echo "UID: $NEW_UID seems to exist check /etc/passwd"
else
  useradd -u $NEW_UID -c "$NEW_COMMENT" -md $NEW_HOMEDIR -s $NEW_SHELL -g $NEW_GROUP -G $NEW_ADDGROUP $NEW_USER
 
  if [ ! -z $NEW_PASS ]
  then
      echo $NEW_PASS | passwd --stdin $NEW_USER
      chage -M $NEW_CHAGE $NEW_USER
      chage -d 0 $NEW_USER 
  fi
fi```

### 注释代码  

描述头适合于添加脚本函数描述，而代码注释适合于解释代码本身的用途。下面仍是上述相同的代码片段，但这次我将添加代码注释，解释代码的用途：  

```
### Parse $x (the csv data) and put the individual fields into variables
NEW_UID=$(echo $x | cut -d: -f1)
NEW_USER=$(echo $x | cut -d: -f2)
NEW_COMMENT=$(echo $x | cut -d: -f3)
NEW_GROUP=$(echo $x | cut -d: -f4)
NEW_ADDGROUP=$(echo $x | cut -d: -f5)
NEW_HOMEDIR=$(echo $x | cut -d: -f6)
NEW_SHELL=$(echo $x | cut -d: -f7)
NEW_CHAGE=$(echo $x | cut -d: -f8)
NEW_PASS=$(echo $x | cut -d: -f9)
 
### Check if the new userid already exists in /etc/passwd
PASSCHK=$(grep -c ":$NEW_UID:" /etc/passwd)
if [ $PASSCHK -ge 1 ]
then
  
### If it does, skip
  echo "UID: $NEW_UID seems to exist check /etc/passwd"
else
  
### If not add the user
  useradd -u $NEW_UID -c "$NEW_COMMENT" -md $NEW_HOMEDIR -s $NEW_SHELL -g $NEW_GROUP -G $NEW_ADDGROUP $NEW_USER
 
  
### Check if new_pass is empty or not
  if [ ! -z $NEW_PASS ]
  then
      
### If not empty set the password and pass expiry
      echo $NEW_PASS | passwd --stdin $NEW_USER
      chage -M $NEW_CHAGE $NEW_USER
      chage -d 0 $NEW_USER 
  fi
fi```

如果你恰好要阅读这段bash代码，却又不知道这段代码的用途，至少可以通过查看注释充分掌握代码的实现目标。在代码中添加注释对其他人非常有帮助，甚至对你自己也有帮助。我曾发现在浏览自己一个月前编写的脚本时不知道脚本的用途。如果注释添加合理，可以在日后节省你和他人的很多时间。  

### 创建描述性的变量名  

描述性变量名非常直观，但我发现自己一直都使用通用变量名。通常这些都是临时变量，从不在该代码块之外使用，但即使是临时变量，解释清楚它们的含义也很有用。


```
INPUT_FILE=$1
for CSV_LINE in `cat $INPUT_FILE`
do
  NEW_UID=$(echo $CSV_LINE | cut -d: -f1)
  NEW_USER=$(echo $CSV_LINE | cut -d: -f2)```
  
  ### 使用$(command) 进行命令替换  
  
  如果你想创建一个变量，其值是其他指令的输出，在bash中有两种方式实现。第一种是将命令封装在反引号中，如下所示：  
  ```
  DATE=`date +%F````  
  
  第二种是使用一个不同的语法：  
  ```
  DATE=$(date +%F)```
  
  虽然两者都正确，但我个人更喜欢第二种方法。这纯粹是个人偏好，但我通常认为$(command)句法比使用反引号更加明显。假如你在挖掘上百行的bash代码；你会发现随着自己不断阅读，那些反引号有时看起来像是单引号。此外，有时单引号看起来像是反引号。最后，所有的建议都与偏好挂钩。所以使用最适合你的，确保与你所选择使用的方法一致。  
  
  ### 在出错退出前描述问题  
  
  上述示例可以让代码更加易于阅读和理解，最后一条建议对在排错过程前找到错误点非常有用。在脚本中添加描述性错误信息，可以在前期节省很多排错时间。浏览下面的代码，看看如何能使它更具描述性：  
  
  ```
  if [ -d $FILE_PATH ]
then
  for FILE in $(ls $FILE_PATH/*)
  do
    echo "This is a file: $FILE"
  done
else
  exit 1
fi```

该脚本首先检查$FILE_PATH变量的值是否是一个目录，如果不是，脚本将退出，并返回一个错误代码1。虽然使用退出代码能够告诉其他脚本该脚本未成功执行，但却没有给运行该脚本的人做出解释。

我们让代码变得更加友好些：  

```
if [ -d $FILE_PATH ]
then
  for FILE in $(ls $FILE_PATH/*)
  do
    echo "This is a file: $FILE"
  done
else
  echo "exiting... provided file path does not exist or is not a directory"
  exit 1
fi```

如果运行第一个代码片段，你将得到大量输出。如果你得不到输出，你将不得不打开脚本文件查看哪些地方可能出错。但如果你运行第二个代码片段，你立刻就能知道是在脚本指定了无效路径。仅添加一行代码就省去了以后大量的排错时间。  
