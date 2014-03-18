---
layout: post
title: "解决oh-my-zsh加载plugin失败问题"
categories:
    - 
tags:
    - zsh
    - oh-my-zsh
    - plugin
    - 失效
    - fail
    - not work
description: ""
---

安装完oh-my-zsh之后plugin无法正常工作，怎么办？

我在mac os x系统上很不幸地遇到了这个问题！

添加一个nvm插件：

```bash
plugins=(git nvm)
```

之前已经用nvm安装了node，但是重启zsh之后，却发现`node command not found`！

plugin没加载吗？ 这个问题困扰了我好几天， 今天终于发现了问题的根源：__PATH路径不对__！

```bash
plugins=(git nvm)
source $HOME/oh-my-zsh.zsh

export PATH=/usr/local/bin/:/usr/bin/
```

尼玛，覆盖了PATH，不挂掉才怪！

正确做法应该是：

```bash
export PATH=$HOME/bin:/usr/local/bin:$PATH
```

如果你也遇到类似问题，那么请检查你的PATH设置。
