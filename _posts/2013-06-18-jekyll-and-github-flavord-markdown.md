---
layout: post
title: "jekyll and github flavored markdown"
tags: 
    - jekyll
    - github
    - markdown
description: ""
---

Github Flavored Markdown使用redcarpet作为markdown渲染引擎, 而jekyll默认是采用Maruku作为渲染引擎的。

不知啥原因（也许是api兼容性问题），jekyll以前的版本并不支持redcarpet，但是从0.12.0开始支持redcarpet。

这就意味着：我们可以在jekyll中使用Github Flavored Markdown了。

## 如何配置？

首先，为了能在本地运行jekyll，我们需要在本机上安装redcarpet：

```bash
gem install redcarpet
```

然后在`_config.yml`文件中配置如下：

```
markdown: redcarpet
```

## 试用一下

jekyll默认情况下，要使用code highlight，得这么写：

{% highlight text %} {% raw %}
{% highlight javascript %}
alert('kao');
{% endhighlight %}
{% endraw %} {% endhighlight %}

哎，君不见Github Flavored Markdown的**围栏式代码块（Fenced code blocks）**写法有多爽：

{% highlight text %} {% raw %}
```javascript
function test() {
   alert('test');
}
```
{% endraw %} {% endhighlight %}

哈哈，瞧，这么写多么简单、快捷，暗爽到内伤！！！
