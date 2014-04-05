---
layout: post
title: "zsh中设置ls目录颜色"
categories:
    -
tags:
    - zsh
    - ls
    - directory
    - color
    - 目录
    - 颜色
description: ""
---

最近把mac的默认shell从bash改成zsh之后，发现ls之后目录没有颜色，不好区分文件和目录。

之前的bash目录是可以正常显示颜色的，看了一眼`bash_profile`中的配置，发现有这样的配置：

```bash
export CLICOLOR=1
```

于是就尝试把这个配置放到`.zshrc`文件中，但是没效果！

google了半天之后，发现如果要显示目录颜色，就得配置`LS_COLORS`或者`LSCOLORS`，mac这种freeBSD系统采用的是后者：

```bash
# LSCOLORS
export LSCOLORS="exfxcxdxbxexexabagacad"
alias ls='ls -G'
```

打开一个新的终端，ls一下，终于看见了目录颜色！
