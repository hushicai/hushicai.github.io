---
layout: post
title: "mac osx命令行下利用goagent作代理"
categories:
    - 
tags:
    - brew install
    - 墙
    - http_proxy
    - https_proxy
description: ""
---

今天在使用brew安装vim7.4时，遭遇了伟大的GFW墙：LuaJit这货总是下载不下来。

于是就开始找代理了，但是手头上只有goagent，没有vpn，咋整？

偶然在一篇文章上发现了curl、wget等http应用程序会调用`http_proxy`和`https_proxy`这两环境变量进行代理，于是我就尝试设置一下：

```bash
export http_proxy=http://127.0.0.1:8087
export https_proxy=$http_proxy
```

_PS：别用`ping`对以上代理进行测试，不管用。_

然后试着重新安装vim7.4，果真不在被墙，成功下载了！并且在goagent的log上也可以观察到：

    INFO - [Apr  8 16:13:33] 127.0.0.1:60865 "GAE GET http://luajit.org/download/LuaJIT-2.0.3.tar.gz HTTP/1.1" 206
    271735 

这说明brew的curl确实使用了我刚才设置的代理。

