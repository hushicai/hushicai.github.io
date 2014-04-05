---
layout: post
title: "添加已有项目到github"
description: ""
---

在本机上搞了一个项目，还没添加版本控制，现在想把它添加到github上，怎么办？

我第一个想法就是这么干：在github上新建一个repo，clone到本机，然后把已有项目的代码拷贝过来。

但是显然，这种方法很不方便，其实可以有更好的办法。

```bash
cd my_project
git init
```

这样就创建了一个local repo，现在就可以把代码添加进去：

```bash
git add .
git commit -m "first commit"
```

ok，接下来就是创建remote repo了，到github上创建一个新的repo，怎么创建可以参考[这里](https://help.github.com/articles/create-a-repo)。

创建完成后，就可以得到一个远程仓库地址，将该地址添加到local repo中：

```bash
git remote add origin https://github.com/yourname/my_project.git
```

更新remote repo到local repo中：

```bash
git pull origin master
```

现在，我们就可以把代码添加到github上了：

```bash
git push origin master
```

到github上查看一下，代码已经提交上去了，搞定！
