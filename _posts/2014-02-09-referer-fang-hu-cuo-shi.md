---
layout: post
title: "referer防护措施"
description: ""
---

`referer`是指请求来源，很多网站通过这个来判断用户是从哪个页面/网站过来的。

`referer`很容易泄露，经常会被攻击者利用，一般情况下，可以采用如下方式来进行`referer`的保护：

* 尽量不要在url中直接带上隐私数据；
* 对第三方链接进行中间跳转，跳转到自己信任的某个页面上，然后在该页面上进行客户端跳转（meta跳转或者javascript跳转）。
* html5草案推荐的`rel="noreferer"`属性，可以让请求不带`referer`

```html
<a href="http://xxx.com" rel="noreferer">noreferer</a>
```
