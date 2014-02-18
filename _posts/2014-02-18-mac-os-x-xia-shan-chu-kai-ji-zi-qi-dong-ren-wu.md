---
layout: post
title: "mac os x下删除开机自启动任务"
description: ""
---


mac os x系统中，自启动任务一般都会在以下某个目录生成一个或多个plist文件：

* /Library/LaunchDaemons/
* /Library/LaunchAgents/
* ~/Library/LaunchAgents/

打开终端，进入到以上几个目录，找到对应的plist文件（有的程序可能有多个plist），然后执行以下命令就可以删除自启动任务：

```bash
launchctl unload -w x.xx.xxx.plist
```

重启mac，该任务应该不会再自动启动了！

在删除自启动任务时，可能会出现以下问题：

    launchctl error unloading

出现这种错误，一般情况下都是因为该自启动任务所属用户与调用unload的用户（也就是本次登录的用户）不符，这个时候可以尝试添加`sudo`。
