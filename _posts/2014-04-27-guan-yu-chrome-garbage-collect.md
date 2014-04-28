---
layout: post
title: "关于chrome garbage collect"
categories:
    - 
tags:
    - 
description: ""
---

js没有显示的内存管理机制，它是自动管理内存的，对于我们创建的任何东西，我们都不需要关心怎么释放它。

我们不知道js什么时候会触发gc（一般是在unload、inactive tab或者存在很多垃圾需要回收时？），而一旦gc发生了，js将暂停执行直至gc完毕。

_参考文章：https://www.scirra.com/blog/76/how-to-write-low-garbage-real-time-javascript_

_参考文章：http://stackoverflow.com/questions/13950394/forcing-garbage-collection-in-google-chrome_

在js中，每个函数调用都会产生一个stack frame，call stack执行完成后不会立马释放，而是会把它放到heap中，等待gc。

_Note：闭包就是利用以上机制实现的，gc时判断对象是否有引用计数，如果有，则不回收，如果没有，立马回收。_

chrome的timeline memory选项记录的就是heap的使用量，因此通常我们都会看到锯齿状的图形。

这种图形通常先是梯形增长，然后某个时刻触发gc后陡降下来，但是如果始终不出发gc，空闲后会趋向平稳直线。

这个时候我们可以手动触发一下chrome的gc，然后再观察一下结果？

_参考文章：http://stackoverflow.com/questions/14034107/does-javascript-setinterval-method-cause-memory-leak_


_参考文章：https://github.com/lukeasrodgers/chrome-timeline-exploration_

至于是否造成内存泄露，要看memory在浏览器gc后，是否会降下来？

_参考文章：http://addyosmani.com/blog/performance-optimisation-with-timeline-profiles/_

对于jsonp来说，有以下几种测试case：

* 不停创建节点，插入到dom中

内存梯形增长，gc时内存会正常降下来，但dom node count不会回到初始值？

* 在上述case的基础上，手工构造一个"dom->object、object->dom"的循环引用

内存梯形增长，gc时内存会小幅度下降，dom node count一直保持增长，最后手工gc时，内存没有完全释放，dom node
count没回到初始值。

这说明产生了memory leak。

* 在上述case的基础上，callback时删除该节点

内存也是梯形增加，gc时内存会小幅度下降，dom node count正常释放，最后手工gc时，内存完全释放，dom node count回到初始值。

_参考文章：https://www.ibm.com/developerworks/library/wa-memleak/_

Dom节点占用的内存与js对象占用的内存两个不同地方？

timeline体现的是js Heap中内存使用量。

为什么没有产生GC？系统忙？



jsonp动态创建的script应不应该处理？怎么处理？有什么副作用？

为什么yui没有删除script节点？出于什么考虑？


