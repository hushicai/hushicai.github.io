---
layout: post
title: "跨域子页面可以修改父页面的location"
description: ""
---

假设父页面localhost:8084/1.html用iframe嵌入了localhost:8085/2.html:

```html
<iframe src="http://localhost:8085/2.html"></iframe>
```

2.html页面内容如下：

```html
<script>
    parent.location = "http://www.baidu.com";
</script>
```

由此可见，跨域的字面是可以修改父页面的location，但是却不能读取父页面的location，跨域读取的时候，会直接抛DOMException。
