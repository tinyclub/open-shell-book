**关注作者公众号**：
<br/>
<img src='../../pic/tinylab-wechat.jpg' width='110px'/>
<br/>

# 用户管理

-    [用户帐号](#toc_13359_11834_1)
    -    [添加](#toc_13359_11834_2)
    -    [删除](#toc_13359_11834_3)
    -    [修改](#toc_13359_11834_4)
    -    [禁用](#toc_13359_11834_5)
-    [用户口令](#toc_13359_11834_6)
    -    [设置](#toc_13359_11834_7)
    -    [删除](#toc_13359_11834_8)
    -    [修改](#toc_13359_11834_9)
    -    [禁用](#toc_13359_11834_10)
-    [用户组别](#toc_13359_11834_11)
    -    [添加](#toc_13359_11834_12)
    -    [删除](#toc_13359_11834_13)
    -    [修改](#toc_13359_11834_14)
-    [用户和组](#toc_13359_11834_15)
    -    [增加](#toc_13359_11834_16)
    -    [删除](#toc_13359_11834_17)
-    [用户切换](#toc_13359_11834_18)
    -    [切换帐号](#toc_13359_11834_19)
    -    [免密码切到 Root](#toc_13359_11834_20)


在初次撰写本书时，都只讨论到了“物”，而没有关注“人”。而在实际使用中，Linux 系统首先是面向用户的系统，所有之前介绍的内容全部是提供给不同的用户使用的。实际使用中常常碰到各类用户操作，所以这里添加一个独立的章节来介绍。

Linux 支持多用户，也就是说允许不同的人使用同一个系统，每个人有一个属于自己的帐号。而且允许大家设置不同的认证密码，确保大家的私有信息得到保护。另外，为了确保整个系统的安全，用户权限又做了进一步划分，包括普通用户和系统管理员。普通用户只允许访问自己账户授权下的信息，而系统管理员才能访问所有资源。普通用户如果想行使管理员的职能，必须获得系统管理员的许可。

为避免分散注意力，咱们不去介绍背后的那些数据文件：
`/etc/passwd`，`/etc/shadow`，`/etc/group`，`/etc/gshadow` 

如果确实有需要，大家可通过如下命令查看帮助：
 `man 5 passwd`，`man shadow`, `man group` 和 `man gshadow`

下面我们分如下几个部分来介绍：

* 用户帐号
* 用户口令
* 用户组别
* 用户和组
* 用户切换

<span id="toc_13359_11834_1"></span>
## 用户帐号

帐号操作主要是增、删、改、禁。Linux 系统提供了底层的 `useradd`, `userdel` 和 `usermod` 来完成相关操作，也提供了进一步的简化封装：`adduser`, `deluser`。为了避免混淆，咱们这里只介绍最底层的指令，这些指令设计上已经够简洁明了方便。

由于只有系统管理员才能创建新用户，请确保以 root 帐号登录或者可以通过 sudo 切换为管理员帐号。

<span id="toc_13359_11834_2"></span>
### 添加

创建家目录并指定登录 Shell：

    # useradd -s /bin/bash -m test
    # groups test
    test : test

并加入所属组：

    # useradd -s /bin/bash -m -G docker test
    # groups test
    test : test docker


<span id="toc_13359_11834_3"></span>
### 删除

删除用户以及家目录等：

    # userdel -r test

<span id="toc_13359_11834_4"></span>
### 修改

常常用来修改默认的 Shell：

    # usermod -s /bin/bash test

或者把用户加入某个新安装软件所属的组：

    # usermod -a -G docker test

修改登录用户名并搬到新家：

    # usermod -d /home/new_test -m -l new_test test

<span id="toc_13359_11834_5"></span>
### 禁用

如果想禁用某个帐号：

    # usermod -L test
    # usermod --expiredate 1 test

<span id="toc_13359_11834_6"></span>
## 用户口令

口令操作主要是设置、删除、修改和禁用。Linux 系统提供了 `passwd` 命令来管理用户口令。

<span id="toc_13359_11834_7"></span>
### 设置

设置用户 test 的初始密码：

    $ passwd test
    Enter new UNIX password:
    Retype new UNIX password:
    passwd: password updated successfully


<span id="toc_13359_11834_8"></span>
### 删除

让用户 test 无须密码登录（密码为空）：

    $ passwd -d test

这个很方便某些安全无关紧要的条件下（比如已登录主机中的虚拟机），可避免每次频繁输入密码。

<span id="toc_13359_11834_9"></span>
### 修改

    $ passwd test
    Changing password for test.
    (current) UNIX password:
    Enter new UNIX password:
    Retype new UNIX password:
    passwd: password updated successfully

<span id="toc_13359_11834_10"></span>
### 禁用

禁止用户通过密码登录：

    $ passwd -l user

为了安全起见或者为了避免暴力破解，我们通常可以禁用密码登录，而只允许通过 SSH Key 登录。

如果要真地禁用整个帐号的使用，需要用上一节提到的 `usermod --expiredate 1`。

<span id="toc_13359_11834_11"></span>
## 用户组别

类似帐号，主要操作也是增、删、改。

Linux 系统提供了底层的 `groupadd`, `groupdel` 和 `groupmod` 来完成相关操作，也提供了进一步的简化封装：`addgroup`, `delgroup`。

用户组别通常用来管理不同的资源，确保只有某个组别的用户才可以访问某类资源。当然，实际案例中，有些软件也为自己定义一个组别，只有该组别的用户才能访问该软件的一些功能。

<span id="toc_13359_11834_12"></span>
### 添加

添加一个新组别：

    # groupadd test

<span id="toc_13359_11834_13"></span>
### 删除

    # groupdel test

<span id="toc_13359_11834_14"></span>
### 修改

修改组别名：

    # groupmod -n new_test test

<span id="toc_13359_11834_15"></span>
## 用户和组

用户和组别不能独立存在，`gpasswd` 可以用来处理两者的关系。

<span id="toc_13359_11834_16"></span>
### 增加

从 docker 组中增加用户 test（等同于把 test 增加到 docker 组中）：

    # gpasswd -a test docker

    或

    # usermod -a -G docker test

<span id="toc_13359_11834_17"></span>
### 删除

从 test 组中删除用户 test：

    # gpasswd -d test test

<span id="toc_13359_11834_18"></span>
## 用户切换

由于支持多用户，那么在登录一个帐号后，可能需要切换到另外一个帐号下，可以通过 `su` 命令完成，而 `sudo` 则可以用来作为另外一个用户来执行命令。

<span id="toc_13359_11834_19"></span>
### 切换帐号

切换到 Root 并启用 Bash：

    $ su -s /bin/bash -
    root@falcon-desktop:~#

    或者

    $ sudo -s

切换到普通用户：

    $ su -s /bin/bash - test
    test@falcon-desktop:~$ 

    或者

    $ sudo -i -u test 
    test@falcon-desktop:~$ 

<span id="toc_13359_11834_20"></span>
### 免密码切到 Root

首先得把用户加入到 sudo 用户组：

    # usermod -a -G sudo falcon

否则，会看到如下信息：

    $ sudo -s
    [sudo] password for test: 
    test is not in the sudoers file.  This incident will be reported.

加入 sudo 用户组以后：

    $ sudo -s
    [sudo] password for test: 

要实现免密切换，需要先修改 `/etc/sudoers`，加入如下一行：

    test ALL=(ALL) NOPASSWD: ALL

或者在 `/etc/sudoers.d/` 下创建一个文件并加入上述内容。

    # echo "test ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/test
    # chmod 440 /etc/sudoers.d/test
