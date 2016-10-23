######1 文件的各种属性  

文件的结构体:  

```bash
struct stat {
	dev_t st_dev; // 设备
    ino_t st_ino; //节点
    mode_t st_mode; //模式
    nlint_t st_nlink; // 硬链接
    uid_t st_uid; // 用户ID
    gid_t st_gid; // 组ID
    dev_t st_rdev; // 设备类型
    off_t st_off; // 文件字节数
    unsigned long st_blksize; // 块大小
    unsigned long st_blocks; // 块数
    time_t st_atime; // 最后访问时间
    time_t st_mtime; // 最后修改时间
    time_t st_ctime; // 最后属性改变时间
};
```
如果需要查看某个文件的属性, 用stat命令即可.

##### 2 文件类型

文件类型对应上面的st_mode, 文件类型包括: 常规文件, 符号链接(硬链接, 软连接), 管道文件, 设备文件(符号设备, 块设备), socket文件等等

`d` 表示目录
`-` 表示普通文件(或硬链接)
`l` 表示符号链接
`p` 表示管道文件
`b` 表示块设备
`c` 表示字符设备
`s` 表示socket文件

###### 管道文件

对于有名管道, 操作规则: 如果你要读它, 除非有内容, 否则阻塞; 如果你要写它, 除非有人来读, 否则阻塞; 通常用于进程通信中.  
可以打开两个Terminal验证一下:

```bash
Terminal1$ cat fif_pipe # 刚开始阻塞在这里, 直到下面的写动作发生, 才打印test字符串
Terminal2$ echo "test" > fifo_pipe
```

###### 给重要文件加锁

```bash
$ chattr +i regular_file
$ lsattr regular_file
---i--------- regular_file
$ rm regular_file # 加了immutable位后, 你无法对文件进行任何"破坏性"的动作
rm: remove write-protected regular file 'regular_fiel'? y
rm: cannot remove 'regular_file': Operation not permitted
$ chattr -i regular_file
$ rm regular_file
```


