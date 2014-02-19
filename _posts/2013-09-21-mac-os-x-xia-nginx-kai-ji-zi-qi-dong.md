---
layout: post
title: "mac os x下nginx开机自启动"
description: ""
---

按照apple developer官网所说的，用户的开机自启动任务一般都需要在以下目录建立一个plist文件：

* /Library/LaunchDaemons/
* /Library/LaunchAgents/
* ~/Library/LaunchAgents/

这次我们在`/Library/LaunchDaemons`下新建一个`nginx.plist`文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>nginx</string>

    <key>Program</key>
    <string>/usr/local/nginx/sbin/nginx</string>

    <key>KeepAlive</key>
    <true/>

    <key>NetworkState</key>
    <true/>

    <key>LaunchOnlyOnce</key>
    <true/>
  </dict>
</plist>
```

然后加载：

    launchctl load /Library/LaunchDaemons/nginx.plist

这样就大功告成了！

同理，php-fpm的开机启动也可以这么做！

参考文档：

* https://developer.apple.com/library/Mac/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html
* http://wiki.nginx.org/OSX_launchd
