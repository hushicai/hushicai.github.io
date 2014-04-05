---
layout: post
title: "命令行中回滚svn"
categories:
    - 
tags:
    - svn
    - command
    - 回滚
    - 命令行
    - 命令
description: ""
---

在命令行环境下，回滚svn代码有以下两种场景：

## 改动还未commit

这种情况下，可以先查看一下`svn status`，看一下哪些文件做了修改：

    M    x/xx/xxx.js

找到了修改了的文件，就可以这样：

```bash
svn revert x/xxx.js
```

如果想回滚整个目录，可以这样：

```bash
svn revert . --recursive # .表示当前目录
```

一旦revert了，本地代码就会丢失，请谨慎操作。

<!-- more -->

## 改动已经commit

这种情况下，我们先拿到更新到最新版本：

```bash
svn update
```

假如拿到的最新版本是88，接下来就确定一下想回滚到哪个版本：

```bash
svn log |less
```

通过查看log找到要回滚的版本，假设是78，如果你想确定一下回滚内容，可以这样：

```bash
svn diff -r 88:78 文件或者目录
```

确认后，就可以用merge命令来回滚了：

```bash
svn merge -r 88:78 文件或者目录
```

可以再次确认一下回滚结果：

```bash
svn diff 文件或者目录
```

确认无误之后，提交回滚结果：

```bash
svn commit - m "revert to revision 78"
```

提交后，版本号就变成了78。
