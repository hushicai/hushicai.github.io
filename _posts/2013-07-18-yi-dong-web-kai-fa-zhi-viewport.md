---
layout: post
title: "移动web开发之viewport"
description: ""
---

移动设备的屏幕比较小，它的viewport就是能用来渲染网页的可视矩形窗口（不包括地址栏以及底部操作栏）。

现代的移动设备浏览器基本上都能处理桌面网页，但是很显然移动屏幕那么小，要显示桌面网页，肯定需要经过一些特殊处理：

> Certain classes of browser attempt to display desktop pages on a small screen
> by automatically zooming the display. This can be problematic for applications
> that have already been optimized for a small screen. The viewport meta tag
> tells the device at what scale to render the page.

_注：引自http://www.w3.org/TR/mwabp/#bp-viewport_

一个典型的viewport meta tag设置如下：

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
```

把上面代码插到页面head标签内，告诉移动浏览器按照设备的100%宽度去渲染页面：

<!-- more -->

> This setting informs the browser to always render the page at 100% (e.g. no
> browser based scaling) and is appropriate for pages specifically designed for
> the target screen-size.

更多viewport内容，请参考以下文章：

* http://developer.apple.com/library/ios/#documentation/AppleApplications/Reference/SafariWebContent/UsingtheViewport/UsingtheViewport.html
* https://developer.mozilla.org/en-US/docs/Mozilla/Mobile/Viewport_meta_tag
