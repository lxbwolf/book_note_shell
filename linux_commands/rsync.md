# rsync

经常这样使用：   
`$ rsync main.c machineB:/home/userB`

1 只要目的端的文件内容和源端不一样，就会触发数据同步，rsync会确保两边的文件内容一样。  
2 但rsync不会同步文件的“modify time”，凡是有数据同步的文件，目的端的文件的“modify time”总是会被修改为最新时刻的时间。  
3 rsync不会太关注目的端文件的rwx权限，如果目的端没有此文件，那么权限会保持与源端一致；如果目的端有此文件，则权限不会随着源端变更。  
4 只要rsync有对源文件的读权限，且对目标路径有写权限，rsync就能确保目的端文件同步到和源端一致。  
5 rsync只能以登陆目的端的账号来创建文件，它没有能力保持目的端文件的输主和属组和源端一致。（除非你使用root权限，才有资格要求属主一致、属组一致）  

####参数  

[-t选项]  
`$ rsync -t main.c machineB:/home/userB`  
1 使用-t选项后，rsync总会想着一件事，那就是将源文件的“modify time”同步到目标机器。  
2 带有-t选项的rsync，会变得更聪明些，它会在同步前先对比两边文件的时间戳和文件大小，如果一致，则就认为两边文件一样，对此文件就不再采取更新动作了。  
3 因为rsync的聪明，也会反被聪明误。如果目的端的文件的时间戳、大小和源端完全一致，但是内容恰巧不一致时，rsync是发现不了的。这就是传说中的“坑”！  
4 对于rsync自作聪明的情况，解决办法就是使用-I选项。

[-I选项] (大写的i，不是l)  
`$ rsync -I main.c machineB:/home/userB`  
1 -I选项会让rsync变得很乖很老实，它会挨个文件去发起数据同步。   
2 -I选项可以确保数据的一致性，代价便是速度上会变慢，因为我们放弃了“quick check”策略。（quick check策略，就是先查看文件的时间戳和文件大小，依次先排除一批认为相同的文件）  
3 无论情况如何，目的端的文件的modify time总会被更新到当前时刻。

[-v选项]

让rsync输出更多的信息：

```bash
$ rsync -vI main.c machineB:/home/userB 
main.c

sent 81 bytes received 42 bytes 246.00 bytes/sec
total size is 11 speedup is 0.09```

你增加越多的v，就可以获得越多的日志信息。
```bash
$ rsync -vvvvt abc.c machineB:/home/userB 
cmd= machine=machineB user= path=/home/userB
cmd[0]=ssh cmd[1]=machineB cmd[2]=rsync cmd[3]=--server cmd[4]=-vvvvte. cmd[5]=. cmd[6]=/home/userB 
opening connection using: ssh machineB rsync --server -vvvvte. . /home/userB 
note: iconv_open("ANSI_X3.4-1968", "ANSI_X3.4-1968") succeeded.
(Client) Protocol versions: remote=28, negotiated=28
(Server) Protocol versions: remote=30, negotiated=28
[sender] make_file(abc.c,*,2)
[sender] flist start=0, used=1, low=0, high=0
[sender] i=0 abc.c mode=0100664 len=11 flags=0
send_file_list done
file list sent
send_files starting
server_recv(2) starting pid=31885
recv_file_name(abc.c)
received 1 names
[receiver] i=0 abc.c mode=0100664 len=11
recv_file_list done
get_local_name count=1 /home/userB
recv_files(1) starting
generator starting pid=31885 count=1
delta transmission enabled
recv_generator(abc.c,0)
abc.c is uptodate
generate_files phase=1
send_files phase=1
recv_files phase=1
generate_files phase=2
send files finished
total: matches=0 hash_hits=0 false_alarms=0 data=0
generate_files finished
recv_files finished
client_run waiting on 14318

sent 36 bytes received 16 bytes 104.00 bytes/sec
total size is 11 speedup is 0.21
_exit_cleanup(code=0, file=main.c, line=1031): entered
_exit_cleanup(code=0, file=main.c, line=1031): about to call exit(0)```

[-z选项]

这是个压缩选项，只要使用了这个选项，rsync就会把发向对端的数据先进行压缩再传输。对于网络环境较差的情况下建议使用。

一般情况下，-z的压缩算法会和gzip的一样。

[-r选项]

我们在第一次使用rsync时，往往会遇到这样的囧境：

```bash
$ rsync superman machineB:/home/userB
skipping directory superman```

如果你不额外告诉rsync你需要它帮你同步文件夹的话，它是不会主动承担的，这也正是rsync的懒惰之处。

所以，如果你真的想同步文件夹，那就要加上-r选项，即recursive（递归的、循环的），像这样：

```bash
$ rsync -r superman machineB:/home/userB```

我们在上面的讲解中说过，如果时间戳和文件大小完全一致，只有文件内容不同，且你没有使用-I选项的话，那么，rsync是不会进行数据同步的。

Linux下文件夹也是文件，如果这类文件（文件夹）也只有内容不同，而时间戳和文件大小都相同，rsync会发现么？  
对于文件夹，rsync是会明察秋毫的，只要你加了-r选项，它就会恪尽职守的进入到文件夹里去检查，而不会只对文件夹本身做“quick check”的。

[-l选项] (小写的L)  

如果我们要同步一个软链接文件，rsync会提示：
```bash
$ ll
total 128
-rw-rw-r-- 1 userA userA 11 Dec 26 07:00 abc.c
lrwxrwxrwx 1 userA userA 5 Dec 26 11:35 softlink -> abc.c
$ rsync softlink machineB:/home/userB
skipping non-regular file "softlink"```

它一旦发现某个文件是软链接，就会无视它，除非我们增加-l选项。

`$ rsync -l softlink machineB:/home/userB`  
使用了-l选项后，rsync会完全保持软链接文件类型，原原本本的将软链接文件复制到目的端，而不会“follow link”到指向的实体文件。

如果想让rsync采取follow link的方式，那就用-L选项就可以了  

[-p选项]

这个选项的全名是“perserve permissions”，顾名思义，就是保持权限。

如果你不使用此选项的话，rsync是这样来处理权限问题的：

1 如果目的端没有此文件，那么在同步后会将目的端文件的权限保持与源端一致；  
2 如果目的端已存在此文件，那么只会同步文件内容，权限保持原有不变。  
如果你使用了-p选项，则无论如何，rsync都会让目的端保持与源端的权限一致的。

[-g选项和-o选项]

这两个选项是一对，用来保持文件的属组(group)和属主（owner），作用应该很清晰明了。不过要注意的一点是，改变属主和属组，往往只有管理员权限才可以。

[-a选项]

1 -a选项是rsync里比较霸道的一个选项，因为你使用-a选项，就相当于使用了-rlptgoD这一坨选项。以一敌七，唯-a选项也  
2 -a选项的学名应该叫做archive option，中文叫做归档选项。使用-a选项，就表明你希望采取递归方式来同步，且尽可能的保持各个方面的一致性。  
3 但是-a无法同步“硬链接”情况。如果有这方面需求，要加上-H选项。

[--delete选项、--delete-excluded选项和--delete-after选项]

三个选项都是和“删除”有关的：

1 –delete：如果源端没有此文件，那么目的端也别想拥有，删除之。（如果你使用这个选项，就必须搭配-r选项一起）
2 –delete-excluded：专门指定一些要在目的端删除的文件。
3 –delete-after：默认情况下，rsync是先清理目的端的文件再开始数据同步；如果使用此选项，则rsync会先进行数据同步，都完成后再删除那些需要清理的文件。

在rsync的官方说明里也有这么一句话：

```
This option can be dangerous if used incorrectly! 
It is a very good idea to run first using the dry run option
(-n) to see what files would be deleted to make sure 
important files aren't listed.```

使用-n选项  
```bash
$ rsync -n --delete -r . machineB:/home/userB/
deleting superman/xxx
deleting main.c
deleting acclink```

[--exclude选项和--exclude-from选项]
如果你不希望同步一些东西到目的端的话，可以使用–exclude选项来隐藏，rsync还是很重视大家隐私的，你可以多次使用–exclude选项来设置很多的“隐私”。

如果你要隐藏的隐私太多的话，在命令行选项中设置会比较麻烦，rsync还是很体贴，它提供了–exclude-from选项，让你可以把隐私一一列在一个文件里，然后让rsync直接读取这个文件就好了。

[--partial选项]

这就是传说中的断点续传功能。默认情况下，rsync会删除那些传输中断的文件，然后重新传输。但在一些特别情况下，我们不希望重传，而是续传。

我们在使用中，经常会看到有人会使用-P选项，这个选项其实是为了偷懒而设计的。以前人们总是要手动写–partial –progress，觉得太费劲了，倒不如用一个新的选项来代替，于是-P应运而生了  

[--progress选项]

使用这个选项，rsync会显示出传输进度信息，下面是rsync的官方解释：

`This gives a bored user something to watch.`