---
layout: post
title: "ajax数据接口的xss风险"
description: ""
---

曾经做过一个网站，用xss漏洞扫描器发现了xss漏洞，查看扫描报告，发现是一个ajax数据接口产生的。

该ajax数据接口中存在类似如下的代码：

```javascript
{
    "a": "<div>xxxx</div>"
}
```

其中xxx数据是来自ajax提交上来的get参数。由于后端没有过滤非法字符，导致了反射型xss漏洞。

最简单直接的解决方法当然就是过滤特殊字符了，但是过滤并不能保证万无一失。

其实还有更靠谱的解决方法：如果在浏览器上直接访问该ajax接口，应该避免以HTML的方式来呈现返回结果。

这就得设置一个正确的content-type了。

该接口原本设置的content-type为`text/javascript`，但这种content-type在firefox、chrome下还是会解析数据中的HTML代码。

其实，正确的content-type应该为`application/json`。

不过就算这么设置，在IE下还是有可能会造成xss。

如果我们直接增加一个URL参数为a.html，IE会很奇葩地认为这是一个HTML文件而忽略content-type，使用HTML来解析文件，比如这样：

    foo.cgi?id=123&a.html
    /index.php/a.html?id=123（mvc单点入口，会忽略a.html，直接请求index.php）
