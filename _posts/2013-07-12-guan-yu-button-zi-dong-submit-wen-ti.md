---
layout: post
title: "关于button自动submit问题"
description: ""
---

最近在做一个项目的过程中，有个同事提出了“`button`在回车的时候会自动submit”的问题，然后还建议我们以后别用`button`，难道`button`真不能用么？

我在w3c上查了，找到了`button`的相关定义（ [传送门](http://www.w3.org/TR/html401/interact/forms.html#h-17.5) ）：

> Buttons created with the BUTTON element function just like buttons created
> with the INPUT element, but they offer richer rendering possibilities: the
> BUTTON element may have content. For example, a BUTTON element that contains
> an image functions like and may resemble an INPUT element whose type is set to
> "image", but the BUTTON element type allows content.

可见，`button`是用来扩展input的，并不是不能用，相反，在有按钮需求的时候，应该多使用`button`。

那是什么原因导致`button`会在回车的时候自动提交呢？回想一下，表单在什么情况下回车会自动提交呢？
请看一下这些 [案例](http://jsfiddle.net/bluthcy/CeUem/) （如果有更多的案例，欢迎补充）

好，现在回到开头的问题，先看看我那同事的需求是怎样的？

> 页面有个输入框和一个查询按钮（表单的一部分，表单还有其他域），用户在输入框输入查询文本后，回车或者点击查询按钮，触发ajax搜索功能，但是不能提交整个表单。

那同事是怎么做的呢？html代码大概类似如下：

```html
<form action="" method="post">
    <!-- 表单中还有其他元素 -->
    <input type="text" /><button>查询</button>
</form>
```

<!-- more -->

页面上并不只一个输入文本框，那么对照上面提到的表单回车自动提交的案例，我们可以排除第二种自动提交情况，即这里的自动提交问题应该是这么产生的：

> 表单中存在一个submit按钮。

难道上面例子中的`button`就是submit按钮？在w3c上查看了一下`button`都有哪些属性定义（链接见上文的传送门）：

* name
* value
* type = submit | button | reset
    
    默认是submit

看到这里，大家都该知道问题所在了吧，`button`这个标签产生了submit按钮，导致在文本输入框中回车会连带将表单也提交了。

解决方案就是显示地指定type，在上面的问题中，是不想提交表单，那么只需要为`button`指定`type="button"`即可。

补充一下，`button`标签在不同浏览器上的默认type是不一样的，测试结果如下：

* chrome、firefox、ie9+默认为submit
* ie8以下默认为button

综上，我们在使用`button`的时候，最好显式地指定`type`。
