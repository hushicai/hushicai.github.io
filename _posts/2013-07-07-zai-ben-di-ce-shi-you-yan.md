---
layout: post
title: "在本地测试友言"
description: ""
---

[友言](http://www.uyan.cc/)是一个加网出品的博客评论系统，类似于国外著名的disqus。

今天刚好在加网上看到了它，就试用了一下。在试用过程中，有一点比较不爽的就是**在本地环境上居然看不到uyan评论系统**。难道真不能？答案是否定的！

于是就开始了苦逼的源代码阅读。

我把友言的js代码找了出来，发现是packer压缩后的，得先把它还原出来。怎么做呢？很简单，把js文件开头的`eval`改成`console.log`，然后用`nodejs`执行一下：

```bash
node iframe.js > uyan.js
```

_注：上面的iframe.js就是这个
[http://v1.uyan.cc/js/iframe.js?UYUserId=1810854](http://v1.uyan.cc/js/iframe.js?UYUserId=1810854)  _。

再把uyan.js格式化一下就可以阅读了。跟踪了一遍执行流程，发现有这么一段代码：

```javascript
init: function() {
    var A = "?url=" + ec(String(conf.url || d.location)),
    B = "&title=" + ec(String(conf.title || d.title)),
    C = "&du=" + ec(UYAN.getDu()),
    D = "&su=" + ec(UYAN.getSu()),
    E = "&pic=" + ec(UYAN.getPic()),
    F = "&vid=" + ec(String(conf.vid ? conf.vid: '')),
    G = "&tag=" + ec(String(conf.tag ? conf.tag: '')),
    I = "&acl=" + ec(UYAN.getACL()),
    H = "&uid=" + (conf.uid || (params['uid'] ? params['uid'] : (params['UYUserId'] ? params['UYUserId'] : ''))),
    SRC = UYAN.apiHost + A + B + C + D + E + F + G + H + I; 
    // ...
    // ...
    UYAN.creElm({
        src: SRC,
        charset: 'utf-8',
        id: 'uyan_script'
    },
    'script', d.getElementsByTagName('head')[0] || dd);
    // ...
}
```

上面创建的这个请求是干嘛的呢？对比了一下线上环境与本地环境，这个请求的返回内容是不一样的，本地的返回内容才几百字节，线上环境有几kb。

这么看来，友言很有可能就是这个请求来决定是否渲染评论系统的！回到上面那段的代码，貌似能导致本地与线上不同的就是这段代码了：

```javascript
var A = "?url=" + ec(String(conf.url || d.location))
```

上面的conf实际上就是`uyan_config`，如果没有配置`uyan_config`，则默认读取当前url，后台如果读取到的是localhost，则决定不渲染评论系统。

看来问题的原因就是:
**本地与线上域名不同**，只要我们能统一域名就可以解决我们的问题。

在官网上查了一下`uyan_config`，还真有这么一个配置项，
http://www.uyan.cc/help/html/customize-url-title, 但是说的并不是我想要的。

我尝试着配置了一下：
    
```javascript
var uyan_uconfig = {
    // production_url: hushicai.com
    url: '{{site.production_url}}{{post.url}}'   
};
```

在本地刷新一下，果然出来了！！！

_注：当然我们也可以配置`127.0.0.1`为我们的线上域名，比如我`hushicia.com`，这样应该也可以解决不能本地调试的问题_
