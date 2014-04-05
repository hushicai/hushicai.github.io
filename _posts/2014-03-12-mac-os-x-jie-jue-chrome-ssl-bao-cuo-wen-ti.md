---
layout: post
title: "mac os x解决chrome ssl报错问题"
categories:
    - 
tags:
    - chrome
    - goagent
    - ssl
    - certificate
    - open
    - parameters
    - 证书错误
description: ""
---

在mac中用goagent，chrome浏览器上经常会报ssl错误，导入证书后，问题依然存在。

依稀记得在windows系统上可以为chrome添加一个启动参数来忽略ssl错误：

    --ignore-certificate-errors

那么mac系统上怎么添加呢？用mac的人应该都知道可以用`open`可以从命令行打开mac的应用程序。

查看了一下`open`的帮助文档，发现了以下有用的信息：

    -a application
        Specifies the application to use for opening the file

    --args
        All remaining arguments are passed to the opened application in the argv parameter to main().  
        These arguments are not opened or interpreted by the open tool.

<!-- more -->

在命令上试一试：

```bash
open -a /Applications/Google\ Chrome.app --args --ignore-certificate-errors
```

居然管用了！

为了后续方便使用，我们可以写一个bash脚本：

```bash
#!/bin/bash
open -a /Applications/Google\ Chrome.app --args --ignore-certificate-errors
```

将以上脚本保存为[chrome.sh](https://github.com/hushicai/dotfiles/blob/master/bash/chrome.sh)，后然修改一下权限：

```bash
chmod +x chrome.sh
```

现在就可以这么打开chrome了：

```bash
./chrome.sh
```

小伙伴们，以后使用goagent的过程中，如果遇到ssl错误，就用上面的`chrome.sh`吧。
