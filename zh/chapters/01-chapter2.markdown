# 数值运算

-    [前言](#toc_22467_18587_1)
-    [整数运算](#toc_22467_18587_2)
    -    [范例：对某个数加 1](#toc_22467_18587_3)
    -    [范例：从 1 加到某个数](#toc_22467_18587_4)
    -    [范例：求模](#toc_22467_18587_5)
    -    [范例：求幂](#toc_22467_18587_6)
    -    [范例：进制转换](#toc_22467_18587_7)
    -    [范例：ascii 字符编码](#toc_22467_18587_8)
-    [浮点运算](#toc_22467_18587_9)
    -    [范例：求 1 除以 13，保留 3 位有效数字](#toc_22467_18587_10)
    -    [范例：余弦值转角度](#toc_22467_18587_11)
    -    [范例：有一组数据，求人均月收入最高家庭](#toc_22467_18587_12)
-    [随机数](#toc_22467_18587_13)
    -    [范例：获取一个随机数](#toc_22467_18587_14)
    -    [范例：随机产生一个从 0 到 255 之间的数字](#toc_22467_18587_15)
-    [其他运算](#toc_22467_18587_16)
    -    [范例：获取一序列数](#toc_22467_18587_17)
    -    [范例：统计字符串中各单词出现次数](#toc_22467_18587_18)
    -    [范例：统计指定单词出现次数](#toc_22467_18587_19)
-    [小结](#toc_22467_18587_20)
-    [资料](#toc_22467_18587_21)
-    [后记](#toc_22467_18587_22)


<span id="toc_22467_18587_1"></span>
## 前言

从本文开始，打算结合平时积累和进一步实践，通过一些范例来介绍Shell编程。因为范例往往能够给人以学有所用的感觉，而且给人以动手实践的机会，从而激发人的学习热情。

考虑到易读性，这些范例将非常简单，但是实用，希望它们能够成为我们解决日常问题的参照物或者是“茶余饭后”的小点心，当然这些“点心”肯定还有值得探讨、优化的地方。

更复杂有趣的例子请参考 [Advanced Bash-Scripting Guide][2] (一本深入学习 Shell 脚本艺术的书籍)。

 [2]: http://www.tldp.org/LDP/abs/html/

该序列概要：

* 目的：享受用 Shell 解决问题的乐趣；和朋友们一起交流和探讨。
* 计划：先零散地写些东西，之后再不断补充，最后整理成册。
* 读者：熟悉 Linux 基本知识，如文件系统结构、常用命令行工具、Shell 编程基础等。
* 建议：看范例时，可参考[《Shell基础十二篇》][3]和[《Shell十三问》][4]。
* 环境：如没特别说明，该系列使用的 Shell 将特指 Bash，版本在 3.1.17 以上。
* 说明：该序列不是依据 Shell 语法组织，而是面向某些潜在的操作对象和操作本身，它们反应了现实应用。当然，在这个过程中肯定会涉及到 Shell 的语法。

 [3]: http://bbs.chinaunix.net/forum.php?mod=viewthread&tid=2198159
 [4]: http://bbs.chinaunix.net/thread-218853-1-1.html
 [5]: http://bbs.chinaunix.net/forum.php?mod=forumdisplay&fid=24&page=1

这一篇打算讨论一下 Shell 编程中的基本数值运算，这类运算包括：

* 数值（包括整数和浮点数）间的加、减、乘、除、求幂、求模等
* 产生指定范围的随机数
* 产生指定范围的数列

Shell 本身可以做整数运算，复杂一些的运算要通过外部命令实现，比如 `expr`，`bc`，`awk` 等。另外，可通过 `RANDOM` 环境变量产生一个从 0 到 32767 的随机数，一些外部工具，比如 `awk` 可以通过 `rand()` 函数产生随机数。而 `seq` 命令可以用来产生一个数列。下面对它们分别进行介绍。

<span id="toc_22467_18587_2"></span>
## 整数运算

<span id="toc_22467_18587_3"></span>
### 范例：对某个数加 1

```
$ i=0;
$ ((i++))
$ echo $i
1

$ let i++
$ echo $i
2

$ expr $i + 1
3
$ echo $i
2

$ echo $i 1 | awk '{printf $1+$2}'
3
```

说明： `expr` 之后的 `$i`，`+`，1 之间有空格分开。如果进行乘法运算，需要对运算符进行转义，否则 Shell 会把乘号解释为通配符，导致语法错误； `awk` 后面的 `$1` 和 `$2` 分别指 `$i` 和 1，即从左往右的第 1 个和第 2 个数。

用 Shell 的内置命令查看各个命令的类型如下：

```
$ type type
type is a shell builtin
$ type let
let is a shell builtin
$ type expr
expr is hashed (/usr/bin/expr)
$ type bc
bc is hashed (/usr/bin/bc)
$ type awk
awk is /usr/bin/awk
```

从上述演示可看出： `let` 是 Shell 内置命令，其他几个是外部命令，都在 `/usr/bin` 目录下。而 `expr` 和 `bc` 因为刚用过，已经加载在内存的 `hash` 表中。这将有利于我们理解在上一章介绍的脚本多种执行方法背后的原理。

说明：如果要查看不同命令的帮助，对于 `let` 和 `type` 等 Shell 内置命令，可以通过 Shell 的一个内置命令 `help` 来查看相关帮助，而一些外部命令可以通过 Shell 的一个外部命令 `man` 来查看帮助，用法诸如 `help let`，`man expr` 等。

<span id="toc_22467_18587_4"></span>
### 范例：从 1 加到某个数

```
#!/bin/bash
# calc.sh

i=0;
while [ $i -lt 10000 ]
do
	((i++))
done
echo $i
```

说明：这里通过 `while [ 条件表达式 ]; do .... done` 循环来实现。`-lt` 是小于号 `<`，具体见 `test` 命令的用法：`man test`。

如何执行该脚本？

办法一：直接把脚本文件当成子 Shell （Bash）的一个参数传入

```
$ bash calc.sh
$ type bash
bash is hashed (/bin/bash)
```

办法二：是通过 `bash` 的内置命令 `.` 或 `source` 执行

```
$ . ./calc.sh
```

或

```
$ source ./calc.sh
$ type .
. is a shell builtin
$ type source
source is a shell builtin
```

办法三：是修改文件为可执行，直接在当前 Shell 下执行

```
$ chmod ./calc.sh
$ ./calc.sh
```

下面，逐一演示用其他方法计算变量加一，即把 `((i++))` 行替换成下面的某一个：

```
let i++;

i=$(expr $i + 1)

i=$(echo $i+1|bc)

i=$(echo "$i 1" | awk '{printf $1+$2;}')
```

比较计算时间如下：

```
$ time calc.sh
10000

real    0m1.319s
user    0m1.056s
sys     0m0.036s
$ time calc_let.sh
10000

real    0m1.426s
user    0m1.176s
sys     0m0.032s
$  time calc_expr.sh
1000

real    0m27.425s
user    0m5.060s
sys     0m14.177s
$ time calc_bc.sh
1000

real    0m56.576s
user    0m9.353s
sys     0m24.618s
$ time ./calc_awk.sh
100

real    0m11.672s
user    0m2.604s
sys     0m2.660s
```

说明： `time` 命令可以用来统计命令执行时间，这部分时间包括总的运行时间，用户空间执行时间，内核空间执行时间，它通过 `ptrace` 系统调用实现。

通过上述比较可以发现 `(())` 的运算效率最高。而 `let` 作为 Shell 内置命令，效率也很高，但是 `expr`，`bc`，`awk` 的计算效率就比较低。所以，在 Shell 本身能够完成相关工作的情况下，建议优先使用 Shell 本身提供的功能。但是 Shell 本身无法完成的功能，比如浮点运算，所以就需要外部命令的帮助。另外，考虑到 Shell 脚本的可移植性，在性能不是很关键的情况下，不要使用某些 Shell 特有的语法。

`let`，`expr`，`bc` 都可以用来求模，运算符都是 `%`，而 `let` 和 `bc` 可以用来求幂，运算符不一样，前者是 `**`，后者是 `^` 。例如：

<span id="toc_22467_18587_5"></span>
### 范例：求模

```
$ expr 5 % 2
1

$ let i=5%2
$ echo $i
1

$ echo 5 % 2 | bc
1

$ ((i=5%2))
$ echo $i
1
```

<span id="toc_22467_18587_6"></span>
### 范例：求幂

```
$ let i=5**2
$ echo $i
25

$ ((i=5**2))
$ echo $i

25
$ echo "5^2" | bc
25
```

<span id="toc_22467_18587_7"></span>
### 范例：进制转换

进制转换也是比较常用的操作，可以用 `Bash` 的内置支持也可以用 `bc` 来完成，例如把 8 进制的 11 转换为 10 进制，则可以：

```
$ echo "obase=10;ibase=8;11" | bc -l
9

$ echo $((8#11))
9
```

上面都是把某个进制的数转换为 10 进制的，如果要进行任意进制之间的转换还是 `bc` 比较灵活，因为它可以直接用 `ibase` 和 `obase` 分别指定进制源和进制转换目标。

<span id="toc_22467_18587_8"></span>
### 范例：ascii 字符编码

如果要把某些字符串以特定的进制表示，可以用 `od` 命令，例如默认的分隔符 `IFS` 包括空格、 `TAB` 以及换行，可以用 `man ascii` 佐证。

```
$ echo -n "$IFS" | od -c
0000000      t  n
0000003
$ echo -n "$IFS" | od -b
0000000 040 011 012
0000003
```

<span id="toc_22467_18587_9"></span>
## 浮点运算

`let` 和 `expr` 都无法进行浮点运算，但是 `bc` 和 `awk` 可以。

<span id="toc_22467_18587_10"></span>
### 范例：求 1 除以 13，保留 3 位有效数字

```
$ echo "scale=3; 1/13"  | bc
.076

$ echo "1 13" | awk '{printf("%0.3fn",$1/$2)}'
0.077
```

说明： `bc` 在进行浮点运算时需指定精度，否则默认为 0，即进行浮点运算时，默认结果只保留整数。而 `awk` 在控制小数位数时非常灵活，仅仅通过 `printf` 的格式控制就可以实现。

补充：在用 `bc` 进行运算时，如果不用 `scale` 指定精度，而在 `bc` 后加上 `-l` 选项，也可以进行浮点运算，只不过这时的默认精度是 20 位。例如：

```
$ echo 1/13100 | bc -l
.00007633587786259541
```

<span id="toc_22467_18587_11"></span>
### 范例：余弦值转角度

用 `bc -l` 计算，可以获得高精度：

```
$ export cos=0.996293; echo "scale=100; a(sqrt(1-$cos^2)/$cos)*180/(a(1)*4)" | bc -l
4.934954755411383632719834036931840605159706398655243875372764917732
5495504159766011527078286004072131
```

当然也可以用 `awk` 来计算：

```
$ echo 0.996293 | awk '{ printf("%s\n", atan2(sqrt(1-$1^2),$1)*180/3.1415926535);}'
4.93495
```

<span id="toc_22467_18587_12"></span>
### 范例：有一组数据，求人均月收入最高家庭

在这里随机产生了一组测试数据，文件名为 `income.txt`。

```
1 3 4490
2 5 3896
3 4 3112
4 4 4716
5 4 4578
6 6 5399
7 3 5089
8 6 3029
9 4 6195
10 5 5145
```

说明：上面的三列数据分别是家庭编号、家庭人数、家庭月总收入。

分析：为了求月均收入最高家庭，需要对后面两列数进行除法运算，即求出每个家庭的月均收入，然后按照月均收入排序，找出收入最高家庭。

实现：

```
#!/bin/bash
# gettopfamily.sh

[ $# -lt 1 ] && echo "please input the income file" && exit -1
[ ! -f $1 ] && echo "$1 is not a file" && exit -1

income=$1
awk '{
	printf("%d %0.2fn", $1, $3/$2);
}' $income | sort -k 2 -n -r
```

说明：

* `[ $# -lt 1 ]`：要求至少输入一个参数，`$#` 是 Shell 中传入参数的个数
* `[ ! -f $1 ]`：要求输入参数是一个文件，`-f` 的用法见 `test` 命令，`man test`
* `income=$1`：把输入参数赋给 income 变量，再作为 `awk` 的参数，即需处理的文件
* `awk`：用文件第三列除以第二列，求出月均收入，考虑到精确性，保留了两位精度
* `sort -k 2 -n -r`：这里对结果的 `awk` 结果的第二列 `-k 2`，即月均收入进行排序，按照数字排序 `-n`，并按照递减的顺序排序 `-r`。

演示：

```
$ ./gettopfamily.sh income.txt
7 1696.33
9 1548.75
1 1496.67
4 1179.00
5 1144.50
10 1029.00
6 899.83
2 779.20
3 778.00
8 504.83
```

补充：之前的 `income.txt` 数据是随机产生的。在做一些实验时，往往需要随机产生一些数据，在下一小节，我们将详细介绍它。这里是产生 `income.txt` 数据的脚本：

```
#!/bin/bash
# genrandomdata.sh

for i in $(seq 1 10)
do
	echo $i $(($RANDOM/8192+3)) $((RANDOM/10+3000))
done
```

说明：上述脚本中还用到`seq`命令产生从1到10的一列数，这个命令的详细用法在该篇最后一节也会进一步介绍。

<span id="toc_22467_18587_13"></span>
## 随机数

环境变量 `RANDOM` 产生从 0 到 32767 的随机数，而 `awk` 的 `rand()` 函数可以产生 0 到 1 之间的随机数。

<span id="toc_22467_18587_14"></span>
### 范例：获取一个随机数

```
$ echo $RANDOM
81

$ echo "" | awk '{srand(); printf("%f", rand());}'
0.237788
```

说明： `srand()` 在无参数时，采用当前时间作为 `rand()` 随机数产生器的一个 `seed` 。

<span id="toc_22467_18587_15"></span>
### 范例：随机产生一个从 0 到 255 之间的数字

可以通过 `RANDOM` 变量的缩放和 `awk` 中 `rand()` 的放大来实现。

```
$ expr $RANDOM / 128

$ echo "" | awk '{srand(); printf("%d\n", rand()*255);}'
```

思考：如果要随机产生某个 IP 段的 IP 地址，该如何做呢？看例子：友善地获取一个可用的 IP 地址。

```
#!/bin/bash
# getip.sh -- get an usable ipaddress automatically
# author: falcon &lt;zhangjinw@gmail.com>
# update: Tue Oct 30 23:46:17 CST 2007

# set your own network, default gateway, and the time out of "ping" command
net="192.168.1"
default_gateway="192.168.1.1"
over_time=2

# check the current ipaddress
ping -c 1 $default_gateway -W $over_time
[ $? -eq 0 ] && echo "the current ipaddress is okey!" && exit -1;

while :; do
	# clear the current configuration
	ifconfig eth0 down
	# configure the ip address of the eth0
	ifconfig eth0 \
		$net.$(($RANDOM /130 +2)) \
		up
	# configure the default gateway
	route add default gw $default_gateway
	# check the new configuration
	ping -c 1 $default_gateway -W $over_time
	# if work, finish
	[ $? -eq 0 ] && break
done
```

说明：如果你的默认网关地址不是 `192.168.1.1`，请自行配置 `default_gateway`（可以用 `route -n` 命令查看），因为用 `ifconfig` 配置地址时不能配置为网关地址，否则你的IP地址将和网关一样，导致整个网络不能正常工作。

<span id="toc_22467_18587_16"></span>
## 其他运算

其实通过一个循环就可以产生一序列数，但是有相关工具为什么不用呢！`seq` 就是这么一个小工具，它可以产生一序列数，你可以指定数的递增间隔，也可以指定相邻两个数之间的分割符。

<span id="toc_22467_18587_17"></span>
### 范例：获取一序列数

```
$ seq 5
1
2
3
4
5
$ seq 1 5
1
2
3
4
5
$ seq 1 2 5
1
3
5
$ seq -s: 1 2 5
1:3:5
$ seq 1 2 14
1
3
5
7
9
11
13
$ seq -w 1 2 14
01
03
05
07
09
11
13
$ seq -s: -w 1 2 14
01:03:05:07:09:11:13
$ seq -f "0x%g" 1 5
0x1
0x2
0x3
0x4
0x5
```

一个比较典型的使用 `seq` 的例子，构造一些特定格式的链接，然后用 `wget` 下载这些内容：

```
$ for i in `seq -f"http://thns.tsinghua.edu.cn/thnsebooks/ebook73/%02g.pdf" 1 21`;do wget -c $i; done
```

或者

```
$ for i in `seq -w 1 21`;do wget -c "http://thns.tsinghua.edu.cn/thnsebooks/ebook73/$i"; done
```

补充：在 `Bash` 版本 3 以上，在 `for` 循环的 `in` 后面，可以直接通过 `{1..5}` 更简洁地产生自 1 到 5 的数字（注意，1 和 5 之间只有两个点），例如：

```
$ for i in {1..5}; do echo -n "$i "; done
1 2 3 4 5
```

<span id="toc_22467_18587_18"></span>
### 范例：统计字符串中各单词出现次数

我们先给单词一个定义：由字母组成的单个或者多个字符序列。

首先，统计每个单词出现的次数：

```
$ wget -c http://tinylab.org
$ cat index.html | sed -e "s/[^a-zA-Z]/\n/g" | grep -v ^$ | sort | uniq -c
```

接着，统计出现频率最高的前10个单词：

```
$ wget -c http://tinylab.org
$ cat index.html | sed -e "s/[^a-zA-Z]/\n/g" | grep -v ^$ | sort | uniq -c | sort -n -k 1 -r | head -10
    524 a
    238 tag
    205 href
    201 class
    193 http
    189 org
    175 tinylab
    174 www
    146 div
    128 title
```

说明：

* `cat index.html`: 输出 index.html 文件里的内容
* `sed -e "s/[^a-zA-Z]/\n/g"`: 把非字母字符替换成空格，只保留字母字符
* `grep -v ^$`: 去掉空行
* `sort`: 排序
* `uniq -c`：统计相同行的个数，即每个单词的个数
* `sort -n -k 1 -r`：按照第一列 `-k 1` 的数字 `-n` 逆序 `-r` 排序
* `head -10`：取出前十行

<span id="toc_22467_18587_19"></span>
### 范例：统计指定单词出现次数

可以考虑采取两种办法：

* 只统计那些需要统计的单词
* 用上面的算法把所有单词的个数都统计出来，然后再返回那些需要统计的单词给用户

不过，这两种办法都可以通过下面的结构来实现。先看办法一：

```
#!/bin/bash
# statistic_words.sh

if [ $# -lt 1 ]; then
	echo "Usage: basename $0 FILE WORDS ...."
	exit -1
fi

FILE=$1
((WORDS_NUM=$#-1))

for n in $(seq $WORDS_NUM)
do
	shift
	cat $FILE | sed -e "s/[^a-zA-Z]/\n/g" \
		| grep -v ^$ | sort | grep ^$1$ | uniq -c
done
```

说明：

* `if 条件部分`：要求至少两个参数，第一个单词文件，之后参数为要统计的单词
* `FILE=$1`: 获取文件名，即脚本之后的第一个字符串
* `((WORDS_NUM=$#-1))`：获取单词个数，即总的参数个数 `$#` 减去文件名参数（1个）
* `for 循环部分`：首先通过 `seq` 产生需要统计的单词个数序列，`shift` 是 Shell 内置变量（请通过 `help shift` 获取帮助)，它把用户从命令行中传入的参数依次往后移动位置，并把当前参数作为第一个参数即 `$1`，这样通过 `$1`就可以遍历用户所有输入的单词（仔细一想，这里貌似有数组下标的味道）。你可以考虑把 `shift` 之后的那句替换成 `echo $1` 测试 `shift` 的用法

演示：

```
$ chmod +x statistic_words.sh
$ ./statistic_words.sh index.html tinylab linux python
    175 tinylab
     43 linux
      3 python
```

再看办法二，我们只需要修改 `shift` 之后的那句即可：

```
#!/bin/bash
# statistic_words.sh

if [ $# -lt 1 ]; then
	echo "ERROR: you should input 2 words at least";
	echo "Usage: basename $0 FILE WORDS ...."
	exit -1
fi

FILE=$1
((WORDS_NUM=$#-1))

for n in $(seq $WORDS_NUM)
do
	shift
	cat $FILE | sed -e "s/[^a-zA-Z]/\n/g" \
		| grep -v ^$ | sort | uniq -c | grep " $1$"
done
```

演示：

```
$ ./statistic_words.sh index.html tinylab linux python
    175 tinylab
     43 linux
      3 python
```

说明：很明显，办法一的效率要高很多，因为它提前找出了需要统计的单词，然后再统计，而后者则不然。实际上，如果使用 `grep` 的 `-E` 选项，我们无须引入循环，而用一条命令就可以搞定：

```
$ cat index.html | sed -e "s/[^a-zA-Z]/\n/g" | grep -v ^$ | sort | grep -E "^tinylab$|^linux$" | uniq -c
     43 linux
    175 tinylab
```

或者

```
$ cat index.html | sed -e "s/[^a-zA-Z]/\n/g" | grep -v ^$ | sort | egrep  "^tinylab$|^linux$" | uniq -c
     43 linux
    175 tinylab
```

说明：需要注意到 `sed` 命令可以直接处理文件，而无需通过 `cat` 命令输出以后再通过管道传递，这样可以减少一个不必要的管道操作，所以上述命令可以简化为：

```
$ sed -e "s/[^a-zA-Z]/\n/g" index.html | grep -v ^$ | sort | egrep  "^tinylab$|^linux$" | uniq -c
     43 linux
    175 tinylab
```

所以，可见这些命令 `sed`，`grep`，`uniq`，`sort` 是多么有用，它们本身虽然只完成简单的功能，但是通过一定的组合，就可以实现各种五花八门的事情啦。对了，统计单词还有个非常有用的命令 `wc -w`，需要用到的时候也可以用它。

补充：在 [Advanced Bash-Scripting Guide][2] 一书中还提到 `jot` 命令和 `factor` 命令，由于机器上没有，所以没有测试，`factor` 命令可以产生某个数的所有素数。如：

```
$ factor 100
100: 2 2 5 5
```


<span id="toc_22467_18587_20"></span>
## 小结

到这里，Shell 编程范例之数值计算就结束啦。该篇主要介绍了：

* Shell 编程中的整数运算、浮点运算、随机数的产生、数列的产生
* Shell 的内置命令、外部命令的区别，以及如何查看他们的类型和帮助
* Shell 脚本的几种执行办法
* 几个常用的 Shell 外部命令： `sed`，`awk`，`grep`，`uniq`，`sort` 等
* 范例：数字递增；求月均收入；自动获取 `IP` 地址；统计单词个数
* 其他：相关用法如命令列表，条件测试等在上述范例中都已涉及，请认真阅读之

如果您有时间，请温习之。

<span id="toc_22467_18587_21"></span>
## 资料

* [Advanced Bash-Scripting Guide][2]
* [shell 十三问][4]
* [shell 基础十二篇][3]
* SED 手册
* AWK 使用手册
* 几个 Shell 讨论区
    * [LinuxSir.org][6]
    * [ChinaUnix.net][7]

 [6]: http://www.linuxsir.org/bbs/forumdisplay.php?f=60
 [7]: http://bbs.chinaunix.net/forum-24-1.html

<span id="toc_22467_18587_22"></span>
## 后记

大概花了 3 个多小时才写完，目前是 23:33，该回宿舍睡觉啦，明天起来修改错别字和补充一些内容，朋友们晚安！

10 月 31 号，修改部分措辞，增加一篇统计家庭月均收入的范例，添加总结和参考资料，并用附录所有代码。

Shell 编程是一件非常有趣的事情，如果您想一想：上面计算家庭月均收入的例子，然后和用 `M$ Excel` 来做这个工作比较，你会发现前者是那么简单和省事，而且给您以运用自如的感觉。
