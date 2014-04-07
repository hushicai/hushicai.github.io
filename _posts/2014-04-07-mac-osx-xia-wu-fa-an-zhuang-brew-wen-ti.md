---
layout: post
title: "mac osx下无法安装brew问题"
categories:
    - 
tags:
    - mac osx
    - brew
    - openssl
    - 无法安装
    - 卡住
description: ""
---

今天很倒霉，本来想update brew的，结果update半天没成功，一怒之下把它删了重装，悲剧就从删除时刻开始上演！！！

捣鼓了一个下午，始终没法重新装上`brew`，没道理啊，我就按照官网上干的：

````bash
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

但是执行完以上命令之后，却卡住了：

* 命令上一直显示`Downloading and installing Homebrew...`
* 经过一段漫长的时间后，会出现`unable to fetch https://github.com/Homebrew/homebrew.git`

研究很久，没有找到原因，直到晚上的时候，发现python的`https_open`方法也挂了？这就很不寻常了。

很有可能系统的ssl有问题！查看了系统的`openssl`版本，发现不是最新的，我当场就决定先更新一下`openssl`试试。

<!-- more -->

```bash
curl --remote-name http://www.openssl.org/source/openssl-1.0.1f.tar.gz
tar -xzvf openssl-1.0.1f.tar.gz
cd openssl-1.0.1f

./configure darwin64-x86_64-cc --prefix=/usr    # 直接覆盖系统的openssl，所以指定prefix=/usr
make
sudo make install
```

安装完成之后，先试一把`https_open`，居然没问题了！！立马接着再试试安装`brew`，尼玛，终于不卡在`downloading`那了！

## 小结

看了`brew`的安装脚本，它实际上就是通过git安装到本地的，所以下次如果遇到诸如git
clone不了https协议打头的仓库地址，就得先查查系统的`openssl`有没有问题！

当然也有可能是被GFW墙了！如果被墙，那就只能想办法搞个vpn了！
