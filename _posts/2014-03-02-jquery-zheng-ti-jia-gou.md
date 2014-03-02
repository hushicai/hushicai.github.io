---
layout: post
title: "jquery整体架构"
categories:
    - javascript
tags:
    - jquery
    - 整体架构
description: ""
---

本文将探索jQuery是如何从最简单的问题开始，并逐步实现羽翼渐丰的演变过程，从jQuery核心技术的还原过程来理解jQuery框架的搭建原理。

## 原型继承

在JavaScript中，函数无处不在，它可以归置代码段，把相对独立的功能封装在一个函数包中；它可以作为一个对象；它也可以用来实现类。

例如，定义一个最初的jQuery类：

```javascript
var jQuery = function() {
    // ...
};
```

上面定义了一个类，类名叫jQuery，我们可以把它当做一个函数，函数名为jQuery，当然，我们也可以把它当做一个对象，对象名就叫jQuery，在JavaScript，一切都是对象。

上面定义的是jQuery一个空函数，啥都没做，实际上，这个函数就是面向对象语言中所谓的构造函数，是用来创建类的。

JavaScript中就是使用function关键字来定义类的，类最基本的特性就是封装、继承、多态等，JavaScript没有extends、implement等关键字，它的继承是通过原型（prototype）来实现的，js中的每个函数都具有一个prototype属性（不同于```__proto__```），这个属性指向一个原型对象，原型对象中可以定义类的继承方法和属性等。

现在我们就来扩展jQuery的原型：

```javascript
var jQuery = function() {};
jQuery.prototype = {
    // ...
};
```
如果你觉得jQuery.prototype名称太长，木有关系，你可以为其重新命名，如fn：

```javascript
jQuery.fn = jQuery.prototype = {
    // ...
}
```

当然，如果你还觉得jQuery名称太长，你也可以给jQuery定义一个别名，比如$：

```javascript
var $ = jQuery = function() {};
```

接下来我们给jQuery的原型对象添加一个方法size和一个属性jquery：

```javascript
var $ = jQuery = function() {};

jQuery.fn = jQuery.prototype = {
    jquery: '1.3.2',
    size: function() {
        return this.length;
    }
};
```

如何调用这些方法和属性呢？


##实例化

回想一下jquery的调用方式：

```javascript
$('xxx').jquery
$('xxx').size();
```

很显然，上面我们构造的代码并不支持这样的调用方式。

既然jquery属性和size方法是jQuery原型对象中的方法，很明显，我们必须先实例化jQuery类。

实例化，当然少不了new操作符，如果按以下方式实现，是不是可以做到实例化呢？

```javascript
var $ = jQuery = function() {
    return new jQuery();
};
```

在浏览器试一下就知道，毫无疑问内存溢出了！

仔细观察一下，$()与new jQuery()调用的是同一个函数，只不过是以不同方法调用而已，所以循环调用了。

那假如在jQuery中使用一个工厂方法来创建实例，并且把这个方法放在jQuery.prototype原型对象中呢？

```javascript
var $ = jQuery = function() {
    return jQuery.fn.init();
};

jQuery.fn = jQuery.prototype = {
    init: function() {
        return this; 
    },
    jquery: '1.3.2',
    size: function() {
        return this.length;
    }
};
alert($().jquery);   //1.3.2
alert($().size());  //undefined
```

现在貌似已经有点jquery雏形了。

##分隔原型

`jQuery.fn.init`方法中，返回的是this关键字，不过该关键字实际上并非jQuery实例，而仅仅是jQuwry.prototype这个对象。

如果这样，那所有`$()`调用返回的都是同一个对象，并且还可以随意往这个对象中增删改属性或者方法，这会干扰彼此的，例如：

```javascript
var $1 = $('#test1');

delete $1.size;

var $2 = $('#test2');
alert($2.size); // undefined
```

这明显是行不通的，怎么办？当然还是得new一下：

```javascript
var $ = jQuery = function() {
    return new jQuery.fn.init();
};
```

jQuery.fn.init被当作一个构造器来调用了，这样一来，`$()`调用的返回值都是一个新的实例，互不干扰！

不过此时$()返回的却是一个jQuery.prototype.init示例，并不能jQuery.prototype中的成员了，怎么办呢？继承一下不就完了：

```javascript
jQuery.fn.init.prototype = jQuery.fn; 
```

## 参考文档

* <<犀利开发——jQuery内核详解与实践>>
