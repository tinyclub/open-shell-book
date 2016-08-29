> 本书来源：[开源书籍：Shell 编程范例](http://www.tinylab.org/open-shell-book/) (by [泰晓科技](http://tinylab.org))<br>
> 报名参与：*Star/fork* [GitHub 仓库](https://github.com/tinyclub/open-shell-book) 并发送 *Pull Request* <br>
> 关注我们：[扫描二维码](#follow) 关注 [@泰晓科技](http://weibo.com/tinylaborg) 微博和微信公众号<br>
> 赞助我们：[赞助 8.99￥](#donate)，[更多原创开源书籍](#more)期待您的支持 ^o^ <br>


# Shell 编程范例

v 0.3

不同于传统 Shell 书籍，本书并未花大篇幅去介绍 Shell 语法，而是以面向“对象” 的方式引入大量的实例介绍 Shell 日常操作，“对象” 涵盖数值、逻辑值、字符串、文件、进程、文件系统等。这样有助于学以致用，并在用的过程中提高兴趣。也可以作为 Shell 编程索引，在需要的时候随时检索。

## 介绍

- 项目首页：<http://www.tinylab.org/open-shell-book>
- 代码仓库：<https://github.com/tinyclub/open-shell-book>
- 在线阅读：<http://tinylab.gitbooks.io/shellbook>

    更多背景和计划请参考：[前言](zh/preface/01-chapter1.markdown)。

### 安装

以 Ubuntu 为例：

    $ sudo aptitude install -y retext git nodejs npm
    $ sudo ln -fs /usr/bin/nodejs /usr/bin/node
    $ sudo aptitude install -y calibre fonts-arphic-gbsn00lp
    $ sudo npm install gitbook-cli -g
    $ sudo rm /usr/local/bin/gitbook
    $ sudo sh -c 'echo "nodejs /usr/local/lib/node_modules/gitbook-cli/bin/gitbook.js \$@" > /usr/local/bin/gitbook'
    $ sudo chmod +x /usr/local/bin/gitbook
    $ gitbook install

### 下载

    $ git clone https://github.com/tinyclub/open-shell-book.git
    $ cd open-shell-book/

### 编译

    $ gitbook build  // 编译成网页
    $ gitbook pdf    // 编译成 pdf

### 纠错

欢迎大家指出不足，如有任何疑问，请邮件联系 wuzhangjin at gmail dot com 或者直接修复并提交 Pull Request。

### 版权

本书采用 ![CC BY NC ND 4.0](http://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png) 协议发布，详细版权信息请参考 [CC BY NC ND 4.0](http://creativecommons.org/licenses/by-nc-nd/4.0/)。

<hr>

### 关注我们

-   [新浪微博](http://weibo.com/tinylaborg)

   [<img src="pic/tinylab-sina.jpg" width="168px"/>](http://weibo.com/tinylaborg)

-   微信公众号

   <img src="pic/tinylab-weixin.jpg" width="168px"/>


<span id="donate"></span>
### 赞助我们

* 微信扫码赞助原创

    <img src="pic/tinylab-sponsor.jpg" width="168px"/>

* 访问 [泰晓开源小店](http://weidian.com/?userid=335178200) 支持心仪项目

    [<img src="pic/tinylab-shop.jpg" width="168px"/>](http://weidian.com/?userid=335178200)

<span id="more"></span>
### 更多原创开源书籍

* [C 语言编程透视](http://tinylab.gitbooks.io/cbook/)
* [嵌入式 Linux 知识库(eLinux.org 中文版)](http://tinylab.gitbooks.io/elinux/)
* [Linux 内核文档(Linux Documentation/ 中文版)](http://tinylab.gitbooks.io/linux-doc/)
