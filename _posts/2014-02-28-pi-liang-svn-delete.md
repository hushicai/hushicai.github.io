---
layout: post
title: "批量svn delete"
categories: 
    -
tags: 
    - 
description: ""
---

如果我们在某个目录中删除了一些已经在svn版本库中的文件或者目录，但是还没commit，`svn status`查看一下状态：

    !   x/xx
    !   x/xx/x.js
    !   x/xx/x.css
    !   x/xx/x.png
    ?   x/xx/x.jpg  ## 起来状态的文件
    M   x/xx/xx.js
    ...

现在我们想`svn delete`一下带"!"状态的文件或者目录，如果被删除的数量不多，我们当然可以挨个`svn delete`。

但是数量很多的情况下，`delete`起来就麻烦了，不可能挨个`delete`，这个时候可以利用shell来批量删除：

```bash
svn status | grep ! | awk '{print $2}' | xargs svn delete
```

再`svn status`一下，可以看到：

    D   x/xx
    D   x/xx/x.js
    D   x/xx/x.css
    D   x/xx/x.png
    ?   x/xx/x.jpg  ## 起来状态的文件
    M   x/xx/xx.js
    ...

已经成功`delete`了，再`commit`一下就搞定了！
