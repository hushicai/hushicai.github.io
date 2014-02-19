---
layout: post
title: "mac os x开机启动goagent"
description: ""
---

怎么在mac os x上让goagent开机自启动呢？

其实很简单，在goagent打包的文件中就有一个叫`addto-startup.py`。

我在目录`goagent/local`下找到了它，那么就需要执行就可以开机自启动了：

```bash
sudo python addto-startup.py
sudo launchctl load /System/Library/LaunchDaemons/org.goagent.macos.plist
```

一切ok！
