# 布尔运算

-    [前言](#toc_17877_9500_1)
-    [常规的布尔运算](#toc_17877_9500_2)
    -    [在Shell下如何进行逻辑运算](#toc_17877_9500_3)
        -    [范例：true or false](#toc_17877_9500_4)
        -    [范例：与运算](#toc_17877_9500_5)
        -    [范例：或运算](#toc_17877_9500_6)
        -    [范例：非运算，即取反](#toc_17877_9500_7)
    -    [Bash里头的 true 和 false 是我们通常认为的1和0么？](#toc_17877_9500_8)
        -    [范例：返回值 v.s. 逻辑值](#toc_17877_9500_9)
        -    [范例：查看 true 和 false 帮助和类型](#toc_17877_9500_10)
-    [条件测试](#toc_17877_9500_11)
    -    [条件测试基本使用](#toc_17877_9500_12)
        -    [范例：数值测试](#toc_17877_9500_13)
        -    [范例：字符串测试](#toc_17877_9500_14)
        -    [范例：文件测试](#toc_17877_9500_15)
    -    [各种逻辑测试的组合](#toc_17877_9500_16)
        -    [范例：如果a，b，c都等于下面对应的值，那么打印YES，通过-a进行与测试](#toc_17877_9500_17)
        -    [范例：测试某个“东西”是文件或者目录，通过-o进行“或”运算](#toc_17877_9500_18)
        -    [范例：测试某个“东西”是否为文件，测试`!`非运算](#toc_17877_9500_19)
    -    [比较-a与&&, -o与||， ! test与test !](#toc_17877_9500_20)
        -    [范例：要求某文件可执行且有内容，用 -a 和 用-a和&&分用-a和&&分 分别实现](#toc_17877_9500_21)
        -    [范例：要求某个字符串要么为空，要么和某个字符串相等](#toc_17877_9500_22)
        -    [范例：测试某个数字不满足指定的所有条件](#toc_17877_9500_23)
-    [命令列表](#toc_17877_9500_24)
    -    [命令列表的执行规律](#toc_17877_9500_25)
        -    [范例：如果 ping 通 www.lzu.edu.cn，那么打印连通信息](#toc_17877_9500_26)
    -    [命令列表的作用](#toc_17877_9500_27)
        -    [范例：在脚本里判断程序的参数个数，和参数类型](#toc_17877_9500_28)
-    [小结](#toc_17877_9500_29)


<span id="toc_17877_9500_1"></span>
## 前言

上个礼拜介绍了[Shell编程范例之数值运算](http://www.tinylab.org/shell-numeric-calculation/)，对 Shell 下基本数值运算方法做了简单的介绍，这周将一起探讨布尔运算，即如何操作“真假值”。

在 Bash 里有这样的常量(实际上是两个内置命令，在这里我们姑且这么认为，后面将介绍)，即 true 和 false，一个表示真，一个表示假。对它们可以进行与、或、非运算等常规的逻辑运算，在这一节，我们除了讨论这些基本逻辑运算外，还将讨论Shell编程中的**条件测试**和**命令列表**，并介绍它们和布尔运算的关系。

<span id="toc_17877_9500_2"></span>
## 常规的布尔运算

这里主要介绍 `Bash` 里头常规的逻辑运算，与、或、非。

<span id="toc_17877_9500_3"></span>
### 在Shell下如何进行逻辑运算

<span id="toc_17877_9500_4"></span>
#### 范例：true or false

单独测试 `true` 和 `false`，可以看出 `true` 是真值，`false` 为假

    $ if true;then echo "YES"; else echo "NO"; fi
    YES
    $ if false;then echo "YES"; else echo "NO"; fi
    NO

<span id="toc_17877_9500_5"></span>
#### 范例：与运算

    $ if true && true;then echo "YES"; else echo "NO"; fi
    YES
    $ if true && false;then echo "YES"; else echo "NO"; fi
    NO
    $ if false && false;then echo "YES"; else echo "NO"; fi
    NO
    $ if false && true;then echo "YES"; else echo "NO"; fi
    NO

<span id="toc_17877_9500_6"></span>
#### 范例：或运算

    $ if true || true;then echo "YES"; else echo "NO"; fi
    YES
    $ if true || false;then echo "YES"; else echo "NO"; fi
    YES
    $ if false || true;then echo "YES"; else echo "NO"; fi
    YES
    $ if false || false;then echo "YES"; else echo "NO"; fi
    NO

<span id="toc_17877_9500_7"></span>
#### 范例：非运算，即取反

    $ if ! false;then echo "YES"; else echo "NO"; fi
    YES
    $ if ! true;then echo "YES"; else echo "NO"; fi
    NO

可以看出 `true` 和 `false` 按照我们对逻辑运算的理解进行着，但是为了能够更好的理解 Shell 对逻辑运算的实现，我们还得弄清楚，`true` 和 `false` 是怎么工作的？

<span id="toc_17877_9500_8"></span>
### Bash里头的 true 和 false 是我们通常认为的1和0么？

回答是：否。

<span id="toc_17877_9500_9"></span>
#### 范例：返回值 v.s. 逻辑值

`true` 和 `false` 它们本身并非逻辑值，它们都是 Shell 的内置命令，只是它们的返回值是一个“逻辑值”：

    $ true
    $ echo $?
    0
    $ false
    $ echo $?
    1

可以看到 `true` 返回了 0，而 `false` 则返回了 1 。跟我们离散数学里学的真值 1 和 0 并不是对应的，而且相反的。

<span id="toc_17877_9500_10"></span>
#### 范例：查看 true 和 false 帮助和类型

    $ help true false
    true: true
         Return a successful result.
    false: false
         Return an unsuccessful result.
    $ type true false
    true is a shell builtin
    false is a shell builtin

说明：`$?` 是一个特殊变量，存放有上一次进程的结束状态（退出状态码）。

从上面的操作不难联想到在 C 语言程序设计中为什么会强调在 `main` 函数前面加上 `int`，并在末尾加上 `return 0` 。因为在 Shell 里，将把 0 作为程序是否成功结束的标志，这就是 Shell 里头 `true` 和 `false` 的实质，它们用以反应某个程序是否正确结束，而并非传统的真假值（1 和 0），相反地，它们返回的是 0 和 1 。不过庆幸地是，我们在做逻辑运算时，无须关心这些。

<span id="toc_17877_9500_11"></span>
## 条件测试

从上节中，我们已经清楚地了解了 Shell 下的“逻辑值”是什么：是进程退出时的返回值，如果成功返回，则为真，如果不成功返回，则为假。

而条件测试正好使用了 `test` 这么一个指令，它用来进行数值测试（各种数值属性测试）、字符串测试（各种字符串属性测试）、文件测试（各种文件属性测试），我们通过判断对应的测试是否成功，从而完成各种常规工作，再加上各种测试的逻辑组合后，将可以完成更复杂的工作。

<span id="toc_17877_9500_12"></span>
### 条件测试基本使用

<span id="toc_17877_9500_13"></span>
#### 范例：数值测试

    $ if test 5 -eq 5;then echo "YES"; else echo "NO"; fi
    YES
    $ if test 5 -ne 5;then echo "YES"; else echo "NO"; fi
    NO

<span id="toc_17877_9500_14"></span>
#### 范例：字符串测试

    $ if test -n "not empty";then echo "YES"; else echo "NO"; fi
    YES
    $ if test -z "not empty";then echo "YES"; else echo "NO"; fi
    NO
    $ if test -z "";then echo "YES"; else echo "NO"; fi
    YES
    $ if test -n "";then echo "YES"; else echo "NO"; fi
    NO

<span id="toc_17877_9500_15"></span>
#### 范例：文件测试

    $ if test -f /boot/System.map; then echo "YES"; else echo "NO"; fi
    YES
    $ if test -d /boot/System.map; then echo "YES"; else echo "NO"; fi
    NO

<span id="toc_17877_9500_16"></span>
### 各种逻辑测试的组合

<span id="toc_17877_9500_17"></span>
#### 范例：如果a，b，c都等于下面对应的值，那么打印YES，通过-a进行"与"测试

    $ a=5;b=4;c=6;
    $ if test $a -eq 5 -a $b -eq 4 -a $c -eq 6; then echo "YES"; else echo "NO"; fi
    YES

<span id="toc_17877_9500_18"></span>
#### 范例：测试某个“东西”是文件或者目录，通过-o进行“或”运算

    $ if test -f /etc/profile -o -d /etc/profile;then echo "YES"; else echo "NO"; fi
    YES

<span id="toc_17877_9500_19"></span>
#### 范例：测试某个“东西”是否为文件，测试`!`非运算

    $ if test ! -f /etc/profile; then echo "YES"; else echo "NO"; fi
    NO

上面仅仅演示了 `test` 命令一些非常简单的测试，你可以通过 `help test` 获取 `test` 的更多用法。需要注意的是，`test` 命令内部的逻辑运算和 Shell 的逻辑运算符有一些区别，对应的为 `-a` 和 `&&`，`-o` 与 `||`，这两者不能混淆使用。而非运算都是 `!`，下面对它们进行比较。

<span id="toc_17877_9500_20"></span>
### 比较-a与&&, -o与||， ! test与test !

<span id="toc_17877_9500_21"></span>
#### 范例：要求某文件可执行且有内容，用 -a 和 用-a和&&分用-a和&&分 分别实现

    $ cat > test.sh
    #!/bin/bash
    echo "test"
    [CTRL+D]  # 按下组合键CTRL与D结束cat输入，后同，不再注明
    $ chmod +x test.sh
    $ if test -s test.sh -a -x test.sh; then echo "YES"; else echo "NO"; fi
    YES
    $ if test -s test.sh && test -x test.sh; then echo "YES"; else echo "NO"; fi
    YES

<span id="toc_17877_9500_22"></span>
#### 范例：要求某个字符串要么为空，要么和某个字符串相等

    $ str1="test"
    $ str2="test"
    $ if test -z "$str2" -o "$str2" == "$str1"; then echo "YES"; else echo "NO"; fi
    YES
    $ if test -z "$str2" || test "$str2" == "$str1"; then echo "YES"; else echo "NO"; fi
    YES

<span id="toc_17877_9500_23"></span>
#### 范例：测试某个数字不满足指定的所有条件

    $ i=5
    $ if test ! $i -lt 5 -a $i -ne 6; then echo "YES"; else echo "NO"; fi
    YES
    $ if ! test $i -lt 5 -a $i -eq 6; then echo "YES"; else echo "NO"; fi
    YES

很容易找出它们的区别，`-a` 和 `-o` 作为测试命令的参数用在测试命令的内部，而 `&&` 和 `||` 则用来运算测试的返回值，`!` 为两者通用。需要关注的是：

-  有时可以不用 `!` 运算符，比如 `-eq` 和 `-ne` 刚好相反，可用于测试两个数值是否相等； `-z` 与 `-n` 也是对应的，用来测试某个字符串是否为空
-  在 `Bash` 里，`test` 命令可以用[] 运算符取代，但是需要注意，[` 之后与 `] 之前需要加上额外的空格
-  在测试字符串时，所有变量建议用双引号包含起来，以防止变量内容为空时出现仅有测试参数，没有测试内容的情况

下面我们用实例来演示上面三个注意事项：

-   `-ne` 和 `-eq` 对应的，我们有时候可以免去 `!` 运算

        $ i=5
        $ if test $i -eq 5; then echo "YES"; else echo "NO"; fi
        YES
        $ if test $i -ne 5; then echo "YES"; else echo "NO"; fi
        NO
        $ if test ! $i -eq 5; then echo "YES"; else echo "NO"; fi
        NO

-   用 `[ ]` 可以取代 `test`，这样看上去会“美观”很多

        $ if [ $i -eq 5 ]; then echo "YES"; else echo "NO"; fi
        YES
        $ if [ $i -gt 4 ] && [ $i -lt 6 ]; then echo "YES"; else echo "NO"; fi
        YES

-   记得给一些字符串变量加上 `""`，记得 `[` 之后与 `]` 之前多加一个空格

        $ str=""
        $ if [ "$str" = "test"]; then echo "YES"; else echo "NO"; fi
        -bash: [: missing `]'
        NO
        $ if [ $str = "test" ]; then echo "YES"; else echo "NO"; fi
        -bash: [: =: unary operator expected
        NO
        $ if [ "$str" = "test" ]; then echo "YES"; else echo "NO"; fi
        NO

到这里，**条件测试**就介绍完了，下面介绍**命令列表**，实际上在上面我们已经使用过了，即多个test命令的组合，通过 `&&`，`||` 和 `!` 组合起来的命令序列。这种命令序列可以有效替换 `if/then` 的条件分支结构。这不难想到我们在 C 语言程序设计中经常做的如下的选择题（很无聊的例子，但是有意义）：下面是否会打印 `j`，如果打印，将打印什么？

    #include <stdio.h>
    int main()
    {
    	int i, j;

    	i=5;j=1;
    	if ((i==5) && (j=5))  printf("%d\n", j);

    	return 0;
    }

很容易知道将打印数字 5，因为 `i==5` 这个条件成立，而且随后是 `&&`，要判断整个条件是否成立，我们得进行后面的判断，可是这个判断并非常规的判断，而是先把 `j` 修改为 5，再转换为真值，所以条件为真，打印出 5 。因此，这句可以解释为：如果 `i` 等于 5，那么把 `j` 赋值为 5，如果 `j` 大于 1 （因为之前已经为真），那么打印出 `j` 的值。这样用 `&&` 连结起来的判断语句替代了两个 `if` 条件分支语句。

正是基于逻辑运算特有的性质，我们可以通过 `&&`，`||` 来取代 `if/then` 等条件分支结构，这样就产生了命令列表。

<span id="toc_17877_9500_24"></span>
## 命令列表

<span id="toc_17877_9500_25"></span>
### 命令列表的执行规律

命令列表的执行规律符合逻辑运算的运算规律，用 `&&` 连接起来的命令，如果前者成功返回，将执行后面的命令，反之不然；用 `||` 连接起来的命令，如果前者成功返回，将不执行后续命令，反之不然。

<span id="toc_17877_9500_26"></span>
#### 范例：如果 ping 通 www.lzu.edu.cn，那么打印连通信息

    $ ping -c 1 www.lzu.edu.cn -W 1 && echo "=======connected======="

非常有趣的问题出来了，即我们上面已经提到的：为什么要让 C 程序在 `main()` 函数的最后返回 0 ？如果不这样，把这种程序放入命令列表会有什么样的结果？你自己写个简单的 C 程序，然后放入命令列表看看。

<span id="toc_17877_9500_27"></span>
### 命令列表的作用

有时用命令列表取代 `if/then` 等条件分支结构可以省掉一些代码，而且使得程序比较美观、易读，例如：

<span id="toc_17877_9500_28"></span>
#### 范例：在脚本里判断程序的参数个数，和参数类型

    #!/bin/bash

    echo $#
    echo $1
    if [ $# -eq 1 ] && (echo $1 | grep ^[0-9]*$ >/dev/null);then
    	echo "YES"
    fi

说明：上例要求参数个数为 1 并且类型为数字。

再加上 `exit 1`，我们将省掉 `if/then` 结构

    #!/bin/bash

    echo $#
    echo $1
    ! ([ $# -eq 1 ] && (echo $1 | grep ^[0-9]*$ >/dev/null)) && exit 1

    echo "YES"

这样处理后，对程序参数的判断仅仅需要简单的一行代码，而且变得更美观。

<span id="toc_17877_9500_29"></span>
## 小结

这一节介绍了 Shell 编程中的逻辑运算，条件测试和命令列表。
