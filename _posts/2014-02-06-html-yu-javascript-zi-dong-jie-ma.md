---
layout: post
title: "HTML与JavaScript自动解码"
description: ""
---

HTML编码字符分为两种表达形式：

* `&#xx;`，xx为十进制数值
* 实体编码，比如`&gt;`等字符

这些字符在不同的上下文中具有不同的表现形式。

### 在HTML上下文中

```html
<script type="text/javascript">
function HtmlEncode(s) {
    return String(s)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}
</script>
<!-- 样例1-->
<input type="button" value="exec1" onclick="document.write('<img src=@ onerror=alert(123) />')" />
<!-- 样例2-->
<input type="button" value="exec2" onclick="document.write('&lt;img src=@ onerror=alert(123) /&gt;')" />
<!-- 样例3-->
<input type="button" value="exec3" onclick="document.write(HtmlEncode(('<img src=@ onerror=alert(123) />'))" />
```

这种上下文中，HTML编码字符会自动解码！上述样例1、样例2的执行结果是一样的。

要想避免自动解码问题，可以使用类似样例3的方法。

<!-- more -->

### 在JavaScript上下文中

通常是指位于script标签之间或者外链js中的代码。

```html
<input type="button" id="exec_btn1" value="exec4" />
<input type="button" id="exec_btn2" value="exec5" />
<script type="text/javascript">
    function g(id) {
        return document.getElementById(id);
    }
    // 样例4
    g('exec_btn1').onclick = function(e) {
        document.write('<img src=@ onerror="alert(123)" />');
    }
    // 样例5
    g('exec_btn2').onclick = function(e) {
        document.write('&lt; img src=@ onerror="alert(123)" /&gt;');
    }
    // ps: chrome、safari下不能document.write('&gt;') ？？？
</script>
```

这种上下文中，HTML编码字符不会自动解码。
