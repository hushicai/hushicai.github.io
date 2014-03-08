---
layout: post
title: "mac os x设置zsh为默认的shell"
categories:
    - 
tags:
    - zsh
    - mac os x
    - shell
description: ""
---

最近老听说zsh别bash好用很多，于是就google一下，结果搜出了一大堆优点，看了一下，有一些特性还真让我感兴趣。

于是就准备玩一玩zsh。

查看了一下mac自带的zsh版本，发现是5.0.2；我又用`brew info zsh`查看了一下最新版本是5.0.5；哈哈，不用说先更新先：

```bash
brew install zsh
```

安装完成后，新版的zsh是安装到`/usr/local/bin`下的，所以为了使用这货，咱还得修改`/etc/shells`这个文件：

```zsh
sudo vi /etc/shells

# 在文件末尾添加
...
/usr/local/bin/zsh
```

修改完成之后：

```zsh
chsh -s /usr/local/bin/zsh
```

现在我们就可以用最新版的zsh了。
