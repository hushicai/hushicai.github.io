---
layout: post
title: "Browser Action与Page Action的区别"
tags: ['browser action', 'page action']
description: ""
---

chrome扩展`Browser Action`与`Page Action`有啥区别？

## Browser Action

这种类型扩展会在chrome的工具栏上显示一个图标，如下图所示：

<img src="/assets/img/tests/chrome-extension-browser-action.png" alt="" width="120" />

当一个extension和很多页面相关时，应该采用`Browser Action`。

一个`Browser Action`扩展可以具备以下几部分：

* icon，图标
* tooltip，悬浮提示
* badge，遮在icon上的文字提示（需要调用api才能显示，不可直接在manifest中配置）
* popup，点击图标时弹出的层

在`manifest.json`中基本配置如下：

```javascript
{
    "name": "my extension",
    ...
    "browser_action": {
        "default_icon": "images/icon.png",
        "default_title": "my extension title",
        "default_popup": "popup.html"
    }
}
```

更多关于`Browser Action`请参考[官方文档](http://developer.chrome.com/extensions/browserAction)。

## Page Action

这种类型扩展会在chrome第地址栏右侧显示一个图标，如下图所示：

<img src="/assets/img/tests/chrome-extension-page-action.png" width="120" alt="" />

当一个extension会依赖于某个页面而显示或隐藏时，应该采用`Page Action`。

一个`Page Action`扩展可以具备以下几个部分：

* icon
* tooltip
* popup

在`manifest.json`中基本配置如下：

```javascript
{
    "name": "my extension",
    ...
    "page_action": {
        "default_icon": "images/icon.png",
        "default_title": "my extension title",
        "default_popup": "popup.html"
    }
}
```

更多关于`Page Action`请参考[这里](http://developer.chrome.com/extensions/pageAction)。
