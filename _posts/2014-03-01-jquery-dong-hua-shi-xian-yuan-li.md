---
layout: post
title: "jquery动画实现原理"
categories:
    - javascript
tags:
    - jquery
    - 动画原理
description: ""
---

最近想写个动画库练练手，在写之前，先看了jquery动画方面的源代码，为此写篇博文记录一下心得体会。

## 概述

jquery动画很强大，它有一个很强大的特性：__动画队列__，比如：

```html
<button id="animation-test">test</button>
<script>
    $('#animation-test').click(function() {
        $(this).animate({width: 200}).animate({opacity: 0.5});
    });
</script>
```

<p>示例：运行一下</p>

<div class="example">
    <button id="animation-test">test</button>
    <script>
        $('#animation-test').click(function() {
           $(this).animate({width: 200}).animate({opacity: 0.5});
        });
    </script>
</div>

可以看到，该按钮的动画按照调用`animate`的顺序播放了！

<!-- more -->

其实在jquery动画中，个人认为，主要就是以下东西：

* 主循环
* 队列
* Tween

当然还有一些其他的，比如deferred等，不过这跟本文没多大关系，本文只讲jquery动画的骨架。

## 动画主循环

我们知道，动画都有一个过渡时间，叫`duration`，而动画要做的事情，就是将`duration`分解成一个一个小时间片段，这些分割点称之为`frame`。

在动画中，最常用的时间分片手段就是`setInterval`（本文不讲关于requestAnimationFrame的内容），jquery就是这么干的：

```javascript
var timerId = null;
jQuery.timers = [];
jQuery.fx.tick = function() {
    // ...
};

jQuery.fx.timer = function( timer ) {
    jQuery.timers.push(timer);
    if(timer()) {

    } else {

    }
    // ...
};

jQuery.fx.interval = 13;

jQuery.fx.start = function() {
    if(!timerId) {
        setInterval(jQuery.fx.tick, jQuery.fx.interval);
    }
    // ...
};

jQuery.fx.stop = function() {
    // ...
};
```

以上是摘自jquery的一段代码，它只用了一个定时器就搞定了所有动画，这个就是所谓的__动画主循环__，它是怎么做到的？

在`Animation`这个方法中，有如下代码：

```javascript
// 帧处理函数
var tick = function() {
    for ( ; index < length ; index++ ) {
        nimation.tweens[ index ].run( percent );
    }
};
var animation = deferred.promise({ //
    // ...
});
// 对每个属性都创建一个Tween对象
jQuery.map(props, createTween, animation);
// 开始计时器，将tick函数添加到jQuery.timers数组中
// 添加时会立马调用一次tick，第一帧（见上述jQuery.fx.timer方法）
// 以后每隔13毫秒都会调用一次
jQuery.fx.timer(tick);

return animation.progress(xxx)
    .done(xxx)
    .fail(xxx).
    always(xxx);

```

每次调用`animate`方法都会进入到`Animation`这个方法中，其实我们可以认为这里生成了一个动画对象。

在这里会把这个动画对象的tick方法放入到`jQuery.timers`中，而上文所说的定时器就会定时扫描这个`timers`数组，发现里面有tick就拿出来执行。

这就是为什么jquery一个定时器搞定了所有动画。

那什么时候会进入到`Animation`这个方法中呢？看一下jquery动画入口方法`animate`的实现：

```javascript
var doAnimation = function() {
    var animation = Animation(xxx); // 调用了Animation这个方法
};
this.queue(doAnimation);  // 入列
```

`animate`只是对`doAnimation`方法进行入列（原代码也有立即执行`doAnimation`的分支，这里就不多讲），什么时候会执行`doAnimation`呢？

## 队列

jquery对相同元素的动画进行了队列控制，并且它是把队列存放到DOM元素上的，在queue方法有以下代码：

```javascript
if(type === 'fx' && queues[0] !== 'inprogress') {
    jQuery.dequeue(this, type);
}
```

入列动画任务时，jquery会判断队列头是不是`inprogress`，如果不是，说明这个元素当前没有在播放动画。

这个时候，jQuery会取出队列的第一个动画任务进行播放，这个逻辑写在`jQuery.dequeue`方法中：

```javascript
var fn = queue.shift();

if(fn) {
    if(type === 'fx') {
        queue.unshift('inprogress');
    }

    fn.call(elem, next, hooks);
}

```

_PS：需要注意的是，jQuery有两个dequeue、queue方法，一个是在jQuery类上，一个是在jQuery的原型上（即jQuery.fn中）_

以上代码需要注意的是`inprogress`这个标志！顾名思义，它是用来标志该元素的队列中是不是有动画正在播放，jquery会在入列、出列的时候检查这个标志，以决定是否播放下一个动画。

还有一个问题：它什么时候播放下一个动画？当然是在上一个动画的complete回调中：

```javascript
// Queueing
opt.old = opt.complete;

opt.complete = function() {
    if ( jQuery.isFunction( opt.old ) ) {
        opt.old.call( this );
    }

    if ( opt.queue ) {
        // 这个时候就会调出下一个动画任务
        jQuery.dequeue( this, opt.queue );
    }
};
```

## Tween

这个类其实逻辑不是特别复杂，jquery会对每个样式属性都创建一个`Tween`对象，它主要是计算和更新元素的样式。

## 小结

以上就是阅读源代码后的一些理解，有不对之处，欢迎纠正/补充！

另，如果想阅读jquery源代码，推荐用github上的，上面的代码是模块化，[传送门>>](https://github.com/jquery/jquery)。
