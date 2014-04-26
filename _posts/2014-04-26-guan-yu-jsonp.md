---
layout: post
title: "关于jsonp"
categories:
    -
tags:
    - jsonp memory leak
    - jsonp注意问题/事项
description: ""
---

在前端开发中，`jsonp`常用来解决跨域问题，一般都是通过动态创建script来实现的。

```javascript
function jsonp(src) {
    var script = document.createElement('div');
    script.src = src;
    script.async = true;
    script.charset = 'utf-8';

    document.head.appendChild(script);
}
```

这样就简单地实现了一个jsonp，但是这样就行了吗？

<!-- more -->

先来做一个实验，在chrome下，每隔1s发一个jsonp请求，观察一下chrome timeline面板上的memory mode。

实验代码如下：

```javascript
function x(data) {
    console.log(data);
}
var interval;
function start() {
    interval = setInterval(
        function() {
            jsonp('http://localhost:3000?callback=x');
        },
        1000
    );
}
function stop() {
    clearInterval(interval);
}
// 开始测验
start();
```

_ps：以下所有结果都是在chrome隐私模式下得到的！_

结果如下图所示：

<img src="/assets/images/jsonp-not-remove.png" alt="" width="800">

从图中我们看到，dom节点都未被回收，数量一直在增加中（图中下方那条很陡的线），内存也在逐步增加中。

因此，__jsonp动态创建的script标签是需要额外处理的！__

怎么处理呢？直接删掉可以吗？试一下：

```javascript
function x(data) {
    // 这里直接在callback里面删除script
    // 我是每1s发一个jsonp请求，而每个请求的响应时间才十几毫秒
    // 因此，我可以保证这里删掉的script就是之前发的jsonp请求
    // 在实际应用中，可不能直接这么干，可能需要用到id进行关联
    var script = document.head.getElementsByTagName('script')[0];
    document.head.removeChild(script);
    console.log(data);
}
```

结果如下图所示：

<img src="/assets/images/jsonp-remove.png" alt="" width="800">

从上图我们可以看到，dom节点都被正常回收了！但是内存使用量却在逐步增加中。这是为啥？难道删除节点并不能完全释放内存？

google了一番，发现真存在这种问题，有人建议这么干：删除节点后，同时还得删除节点的各个属性？

_ps：为啥script删除之后，内存没完全释放？这估计得研究研究垃圾回收机制了！_

我又试了一下：

```javascript
function x(data) {
    var script = document.head.getElementsByTagName('script')[0];
    document.head.removeChild(script);
    for(var prop in script) {
        delete script[prop];
    }
    script = null;
    console.log(data);
}
```

结果如下图所示：

<img src="/assets/images/jsonp-remove-and-dispose.png" alt="" width="800">

如上图所示，有两个低谷，节点数和内存使用量都能回到初始状态！

综上，第三次实验的方法应该是个最佳的解决方案（个人意见，如有更好方案，请指导在下）！测试代码见[gist](https://gist.github.com/hushicai/11315775)！

_号外：据说IE可以共用同一个script。_
