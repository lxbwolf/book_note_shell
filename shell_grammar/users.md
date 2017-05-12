# 组用户

Linux用户只有两个等级： root 和非root. Linux下还有一部分用户，如：apache, mysql, nobody, ftp等，都是非root用户, 即普通用户.   
  Linux下的权限实际上是不同用户所能访问的文件的不同产生的假象. 造成这种假象的原因, 涉及到用户组:

* 一个用户至少属于一个用户组  
* 一个用户可以属于多个用户组  

用户组的存在主要是为了分配权限, 用户本身与权限的关系不大, 各用户之间主要的不同:

* 是否拥有密码
* HOME目录
* shell

像nobody这样用来执行Nginx的工作进程的用户，一般不分配密码和shell，甚至连home目录都没有。  
为什么不分配密码？如果设置了密码，程序无法自动使用。由于不会有人使用这个用户登录系统，所以就没有必要分配shell。（备注：其实严格上说是有分配shell，只是分配的shell是/sbin/nologin这个特殊的shell，没有任何其他功能，主要功能是防止你登陆。）

可以在/etc/passwd文件查看所有用户. 文件每一行表示一个用户, 用冒号分割成7个字段:

`user_name：password：UID：GID：full_user_name：home_dir：shell`

UID：  
UID 0 root用户  
UID 1~999 是占坑用户，即一些无法登录的用户（以前是系统是1~499，最近刚改）  
UID 1000 以上是正常的可登录用户

GID：一个用户可以属于多个用户组，但这里只有一个，表示的是专职用户组，即一个用户只有一个专职用户组，其属于其他用户组的关联关系存储在/etc/group 文件中。

其中比较特殊的是密码字段，统一由x代替了，看/etc/passwd就知道一开始Linux是将密码存在这个文件里的，由于考虑到/etc/passwd可以被所有人查看，所以将统一存储到/etc/shadow文件（只有root权限可以访问）中  
结构如下:

```bash
登录名：加密过的密码（*代表此用户不能用来登录）：密码最近更改日期（linux时间戳）：最少密码天数（0代表随时可更改）：最多密码天数：过期前几天提醒用户：密码不可用期限：账户过期日期：保留位
```

/etc/passwd文件, 结构如下:

`组名：用户组密码：GID：用户组内的用户名`

正常的使用中很少会用到用户组密码，其存储在/etc/gshadow中。

用户组文件比较特特殊的是“”用户组内的用户名”，其实就是这个组下的用户列表，每个用户之间用逗号“,”分割；本字段可以为空；如果字段为空表示用户组为GID的用户名  
普通用户的权限非常的低，就连在系统里安装软件的权限都没有，很多时候可以临时给普通用户以特权，就是sudo（在命令前添加sudo）。比如：  
`sudo vi /etc/shadow`

完成后需要输入root的密码，这样 就可以假借root身份了，centos默认普通用户是没有sudo权限的，这与主要以桌面版为主的Ubuntu和Fedora不同，如需给予用户root特权，就需要更改/etc/sudoers文件，修改内容。  
给没有用户添加sudo特权，只需参照

```bash
## Allow root to run any commands anywhere    
root    ALL=(ALL)     ALL
```

添加如下:

```bash
## Allow root to run any commands anywhere    
root    ALL=(ALL)     ALL   
qw    ALL=(ALL)     ALL
```

如果要给某个用户组添加sudo特权则为：（与给用户不同的是多了一个%）

```bash
## Allows people in group wheel to run all commands   
%wheel ALL=(ALL) ALL
```

另外一种方式是添加不需要输入root密码即有root权限的用户，添加方法如下：

`qw    ALL=(ALL)     NOPASSWD:ALL`

默认情况下第一次使用sudo时，需要输入root密码，如果5分钟内再次执行sudo则无需再输入密码，超过5分钟则要重新输入。这个时间也是可以进行配置的，在sudoers中添加如下内容即可：  
`ts:用户名 timestamp_timeout=20`  
其中单位是分钟，如果设为0，则表示每次都要输入密码。

### 相关的shell命令

useradd命令用于Linux中创建的新的系统用户。useradd可用来建立用户帐号。帐号建好之后，再用passwd设定帐号的密码．而可用userdel删除帐号。使用useradd指令所建立的帐号，实际上是保存在/etc/passwd文本文件中。  
语法 ： useradd \(选项\) \(参数\)  
常用选项:

* -s 指定用户登入后所使用的shell
* -d 设置用户主目录
* -g 用户组
* -m 创建用户目录
* -M 不要自动建立用户的登入目录

如:  
`sudo useradd username -m -s /sbin/nologin -d /home/username -g groupname`  
备注: -s /sbin/nologin 设置不能登陆

