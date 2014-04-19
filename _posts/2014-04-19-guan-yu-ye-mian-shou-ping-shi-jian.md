---
layout: post
title: "关于页面首屏时间"
categories:
    - 
tags:
    - 首屏时间
    - 首字节时间
    - 开始渲染时间
    - 白屏时间
    - above the fold
    - Time Of First Byte
    - Start Render Time
description: ""
---

什么是首屏？英文叫`above the fold`，google一下`above the fold`，可以发现在维基百科上有专门的[条目](http://en.wikipedia.org/wiki/Above_the_fold) 。

正如维基百科上所说，`above the fold`这个概念最早出现在报纸上，也就是我们通常所说的报纸头条！

这个概念后来被沿用到web上，web中的`above the fold`，维基百科是这么解释的:

>Above the fold is also used in website design (along with "above the scroll") to refer to the portion of the webpage
>that is visible without scrolling. As screen sizes vary drastically there is no set definition for the number of
>pixels that define the fold. This is because different screen resolutions will show different portions of the website
>without scrolling. Further complicating matters, many websites adjust their layout based on the size of the browser
>window, such that the fold is not a static feature of the page.

如上文所说，web中的首屏不同于报纸头条，它的区域是动态的，因为用户的屏幕分辨率是不同的。

那我们应该怎么确定这个首屏范围呢？这个范围需要根据用户的浏览器分辨率数据来制定。

在web中，一般我们只需要敲定一个高度，然后得到一条_首屏线_。

首屏线以上的内容通常是一个站点想优先展现给用户的东西，它能不能及时展示是能不能留住用户一个非常重要的因素。

<!-- more -->

## 首屏时间

用户访问一个站点时，浏览器会首先发出一个请求，请求该html文档，浏览器接收到文档内容时，开始解析并渲染到窗口上。

在这个过程中，有两个时间点比较重要：

* `Time Of First Byte`
* `Start Render Time`

这两个时间点将首屏时间分为了三段，如下图所示：

<img src="/assets/images/above-the-fold.png" alt="">

通过这两个时间点，我们可以更好地分析首屏时间的瓶颈到底在哪个阶段中。

### Time Of First Byte

浏览器请求一个文档，需要经过blocking、proxying、dns
lookup、connecting、sending、waiting等过程，首字节时间点就是用来衡量这些过程的性能的一个关键指标。

首字节时间越长，浏览器就越晚解析文档，首屏时间就越长。

如果首字节时间越长，那么瓶颈应该应该是存在于网络、后端程序等方面。

### Start Render Time

`Start Render Time`是指用户屏幕刚开始显示某些内容的时刻。

浏览器屏幕刚开始是一大片空白，绘制时会发生一些变化，可能是显示背景、logo或者文字等。

看过浏览器工作原理的小伙伴们应该都知道，非可视化的DOM元素不会显示到窗口中，例如head，这就意味着浏览器在绘制之前，
至少需要先解析完head元素中的内容。

一般情况下，body元素是HTML文档中第一个可视化元素，因此，我们也可以认为浏览器开始解析body标签的时刻就是`Start Render
Time`，利用这一点，我们可以在body标签内的开始处埋入一段脚本（也有的是在head的结束处埋入脚本），用以获取这个`Start Render Time`。

_PS：请参考[浏览器的工作原理](http://www.html5rocks.com/zh/tutorials/internals/howbrowserswork/)。_

这个时间减去首字节时间，就是head标签的解析时间，从而我们就能知道head标签中的内容是否拖长了首屏时间。

_Note: 通常这个时间也叫白屏时间或者First Paint Time等。_

### 首屏渲染时间

当我们指定了一个首屏线之后，首屏线以上的内容就是我们所说的首屏，这个区域本身也需要时间来渲染的。

这个区域的资源越多（css、js、img等），其渲染时间就越长，首屏时间也就越长。

## 如何测量首屏时间

前面提到web中的首屏需要根据用户屏幕分辨率数据确定一个首屏线，首屏线以上的内容就是首屏。

怎么测量首屏花费了多少时间呢？

现在大部分浏览器端的做法都是在首屏线处埋点标记，然后计算标记点之前所有图片加载完成的时间，把这个时间作为首屏时间。

很显然这种做法，误差不小，但是貌似没什么好办法。

也有人提到用`phantomjs`、`berserkjs`等来做，不知道是否可行，待验证。

## 小结

综上，如果我们发现站点的首屏时间很长，应该从以下三方面逐步进行排查:

* `Time Of First Byte`，通常可以通过cdn、cache、chunked、提升后台程序性能等手段来优化；
* `Start Render Time`，通常是避免在head中使用过多资源，比如将js放到body结束处等；
* 首屏时间，通常做法是减少首屏区域内容，或者用lazyload等手段来优化；

如果你想监控站点的性能，可以使用yslow、pagespeed等工具

## 参考文章

* http://www.websiteoptimization.com/speed/tweak/time-to-first-byte/
* http://www.websiteoptimization.com/speed/tweak/start-render/
* http://www.webpagetest.org/forums/showthread.php?tid=15
* https://dvcs.w3.org/hg/webperf/raw-file/tip/specs/NavigationTiming/Overview.html
