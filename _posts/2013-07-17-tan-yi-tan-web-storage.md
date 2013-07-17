---
layout: post
title: "谈一谈web storage"
description: ""
---

web storage就是我们常说的**本地存储**，在这里我不多说web
storage，想深入了解可以自己到以下网址看：

* http://dev.w3.org/html5/webstorage/
* https://developer.mozilla.org/en-US/docs/Web/Guide/DOM/Storage

这里想说的是，怎么实现一个跨浏览器的`localStorage`。先看看哪些浏览器支持`localStorage`？

> http://caniuse.com/namevalue-storage

caniuse上面的统计很详细，我们只关注pc端浏览器的支持情况：

* ie 8.0+
* firefox 3.5+
* chrome 4.0+

咦，稍等！caniuse上面统计的firefox 2.0、3.0部分支持localStorage是神马意思？请看以下 [引文](https://developer.mozilla.org/en-US/docs/Web/Guide/DOM/Storage)：

> localStorage is also the same as globalStorage[location.hostname], with the
> exception of being scoped to an HTML5 origin (scheme + hostname + non-standard
> port) and localStorage being an instance of Storage as opposed to
> globalStorage[location.hostname] being an instance of StorageObsolete which is
> covered below. 

原来是firefox初期版本的非标准实现`globalStorage`，但是：

> globalStorage is obsolete since Gecko 1.9.1 (Firefox 3.5) and unsupported
> since Gecko 13 (Firefox 13). Just use localStorage instead. This proposed
> addition to HTML5 has been removed from the HTML5 specification in favor of
> localStorage, which is implemented in Firefox 3.5. This is a global object
> (globalStorage) that maintains multiple private storage areas that can be used
> to hold data over a long period of time (e.g. over multiple pages and browser
> sessions).

好，firefox 3.5以后就废弃了`globalStorage`了，那么按照现在国内大部分前端开发的浏览器支持需求，firefox 2、3基本上可以无视了，我们就可以不再考虑globalStorage了。

现在就差ie6、ie7缺少支持了，怎么办呢？也许你会有以下这么几种想法：

* cookie
* userData

cookie的实现成本较低，比较容易，但是它的缺点太明显了：

* 每一个domain下限制4kb（包括name、value、=），可存储的数据太少了。
* cookie的内容每次都会随着http请求往返客户端-服务端，加重了网络负载。

以上两个缺点就足以丢弃cookie实现方案了吧，那看来只能使用userData了：

> http://msdn.microsoft.com/en-us/library/ms531424(v=vs.85).aspx

综合以上，我们只需要按照w3c的标准提供相应的api就可以实现一个跨浏览器的`localStorage`了，这里有个实现方案，有兴趣的可以去瞧瞧，
[传送门](https://github.com/andris9/jStorage)。
