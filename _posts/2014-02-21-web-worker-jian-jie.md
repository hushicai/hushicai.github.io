---
layout: post
title: "web worker简介"
description: ""
---

[Web Worker](http://www.whatwg.org/specs/web-apps/current-work/multipage/workers.html)规范定义了在网络应用中生成背景脚本的API。

我们可以通过Web Worker执行一些操作，例如触发长时间运行的脚本以处理计算密集型任务，同时却不会阻碍 UI或其他脚本处理用户互动。

值得注意的是，[规范](http://www.whatwg.org/specs/web-apps/current-work/multipage/workers.html)中提到了两种Worker：[专用Worker](http://www.whatwg.org/specs/web-apps/current-work/multipage/workers.html#dedicated-workers-and-the-worker-interface)以及[共享Worker](http://www.whatwg.org/specs/web-apps/current-work/multipage/workers.html#shared-workers-and-the-sharedworker-interface)。本文只讲专用Worker，下文称之为“Web Worker”或“Worker”。

## 入门

`Web Worker`是在独立线程中运行的，因此，它们执行的代码需要保存在一个单独的文件中，我们可以这样创建一个Worker：

```javascript
var worker = new Worker('/assets/js/tests/simple-web-worker.js');
```

如果指定的异步下载文件存在，浏览器就会生成新的Worker线程。在完全下载并执行文件之前，系统不会生成Worker。如果指定的文件不存在，Worker就不会创建成功。

## 全局作用域

Worker拥有一个独立于JavaScript执行环境的全局作用域，它不能访问DOM以及大部分BOM，它只能使用JavaScript的一部分功能：

* `XMLHttpRequest`
* `self`，Worker作用域内的全局对象，等同于Worker中的`this`
* `navigator`，这是个被阉割的对象，在Worker中，它仅包含了部分属性
* `location`，等同于`window.location`，但是所有属性都是只读的。
* `setTimeout`和`setInterval`
* 一个`importScripts`方法，用于向Worker注入外部脚本文件。
* 所有ECMAScript规范中定义的构造器。

既然是一个独立的执行环境，那Worker中的所有全局变量都应该是`self`的属性，比如：

```javascript
onmessage = function(e) {
    // ...
}
```

这样写虽然没问题，但是不好理解，所以建议这么写：

```javascript
self.onmessage = function(e) {
    // ...
}
```

其实，更优雅的方式应该是这样：

```javascript
self.addEventListener('message', function(e) {
    // ...
}, false);
```

## 消息传递

Worker不能直接影响页面，它需要通过一个消息系统来传递消息。

Worker可以通过`postMessage`方法来传递消息，例如：

<!-- more -->

主页面：

```html
<button onclick="sayHI()">打招呼</button>
<button onclick="sayBalala()">随便说一句</button>
<button onclick="sayBye()">停止</button>
<output id="result"></output>

<script type="text/javascript">
    function sayHI() {
        worker.postMessage({
            cmd: 'start',
            msg: 'HI, ' + (+new Date)
        });
    }
    function sayBalala() {
        worker.postMessage({
            cmd: 'balala',
            msg: 'balala, ' + (+new Date)
        });
    }
    function sayBye() {
        worker.postMessage({
            cmd: 'stop',
            msg: 'Bye'
        });
    }

    var worker = new Worker('/assets/js/tests/simple-web-worker.js');
    worker.addEventListener('message', function(e) {
        document.getElementById('result').innerHTML = e.data;
    }, false);
</script>
```

在Worker文件中：

```javascript
self.addEventListener('message', function(e) {
    var data = e.data;

    switch(data.cmd) {
        case 'start':
            self.postMessage('Worker started: ' + data.msg);
            break;
            break;
        case 'stop':
            self.postMessage('Worker stopped: ' + data.msg);
            self.close();
            break;
        default:
            self.postMessage('unkown command: ' + data.msg);
    }
}, false);
```

**示例**：运行此Worker！

<div class="example">
    <button onclick="sayHI()">打招呼</button>
    <button onclick="sayBalala()">随便说一句</button>
    <button onclick="sayBye()">停止</button>
    <output id="result"></output>

    <script type="text/javascript">
        function sayHI() {
            worker.postMessage({
                cmd: 'start',
                msg: 'HI, ' + (+new Date)
            });
        }
        function sayBalala() {
            worker.postMessage({
                cmd: 'balala',
                msg: 'balala, ' + (+new Date)
            });
        }
        function sayBye() {
            worker.postMessage({
                cmd: 'stop',
                msg: 'Bye'
            });
        }

        var worker = new Worker('/assets/js/tests/simple-web-worker.js');
        worker.addEventListener('message', function(e) {
            document.getElementById('result').innerHTML = e.data;
        }, false);
    </script>
</div>

## 后记

在使用Worker时，可能需要关闭Worker，通常有以下两种办法：

* 在主线程脚本中调用`worker.terminate()`
* 在Worker内部中调用`self.close()`

Worker一旦关闭后，就不再可用。
