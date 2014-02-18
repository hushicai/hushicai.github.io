---
layout: post
title: "vml元素设置css opacity样式导致的图像锯齿问题"
description: ""
---

使用vml创建图形时，因为图形下还有一张底图，所以需要将vml创建的图形设置一定的透明度，以便可以看见下面的底图。

开始时，使用了ie的滤镜透明`filter:alpha(opacity=xxx)`来设置图形的透明度，结果在ie下出现了描边锯齿。

```html
<style type="text/css">
    .shape {
        opacity: 0.5;
        filter: alpha(opacity=50)
    }
</style>

<v:shape class="shape">
    <v:fill color="red"></v:fill>
    <v:stroke color="red"></v:stroke>
</v:shape>
```

起初还以为是vml的数字精度问题导致的，后来排查了大半天才发现是使用了滤镜透明导致的。

改成vml元素的opacity属性才干掉了锯齿：

```html
<v:shape class="shape">
    <v:fill color="red" opacity="0.5"></v:fill>
    <v:stroke color="red" opacity="0.5"></v:stroke>
</v:shape>
```
