---
layout: post
title: "HTML5读取本地文件"
categories:
    -
tags:
    - HTML5
    - File Api
    - FileReader
    - 本地文件
description: ""
---

常见的语言比如php、shell等，是如何读取文件的呢？

实际上，大多数语言都需要先获取文件句柄，然后调用文件访问接口，打开文件句柄，读取文件！

那么，HTML5是否也是这样的呢？

答案是肯定的！

HTML5为我们提供了一种与本地文件系统交互的标准方式：[File Api](http://www.w3.org/TR/file-upload/)。

该规范主要定义了以下数据结构：

* `File`
* `FileList`
* `Blob`

HTML5访问本地文件系统时，需要先获取`File`对象句柄，怎么获取文件引用句柄呢？

<!-- more -->

## 选择文件

首先检测一下当前浏览器是否支持`File Api`：

```javascript
function isSupportFileApi() {
    if(window.File && window.FileList && window.FileReader && window.Blob) {
        return true;
    }
    return false;
}
```

运行此示例：

<div class="example">
<input type="button" value="检测" onclick="checkFileApi()" />
<script type="text/javascript">
function isSupportFileApi() {
    if(window.File && window.FileList && window.FileReader && window.Blob) {
        return true;
    }
    return false;
}
function checkFileApi() {
    if(isSupportFileApi()) {
        alert('支持File Api!');
        return;
    }
    alert('不支持File Api!');
}
</script>
</div>

HTML5虽然可以让我们访问本地文件系统，但是js只能被动地读取，也就是说只有用户主动触发了文件读取行为，js才能访问到`File
Api`，这通常发生在__表单选择文件__或者__拖拽文件__。

### 表单输入

表单提交文件是最常见的场景，用户选择文件后，触发了文件选择框的change事件，通过访问文件选择框元素的`files`属性可以拿到选定的文件列表。

如果文件选择框指定了multiple，则一个文件选择框可以同时选择多个文件，`files`包含了所有选择的文件对象；如果没有指定，则只能选择一个文件，`files[0]`就是所选择的文件对象。

```javascript
function fileSelect1(e) {
    var files = this.files;
    for(var i = 0, len = files.length; i < len; i++) {
        var f = files[i];
        html.push(
            '<p>',
                f.name + '(' + (f.type || "n/a") + ')' + ' - ' + f.size + 'bytes',
            '</p>'
        );
    }
    document.getElementById('list1').innerHTML = html.join('');
}
document.getElementById('file1').onchange = fileSelect1;
```

运行此示例：

<div class="example">
<p><input type="file" id="file1" multiple /></p>
<div id="list1"></div>
<script type="text/javascript">
(function() {
var html = [];
function fileSelect1(e) {
    var files = this.files;
    for(var i = 0, len = files.length; i < len; i++) {
        var f = files[i];
        html.push(
            '<p>',
                f.name + '(' + (f.type || "n/a") + ')' + ' - ' + f.size + 'bytes',
            '</p>'
        );
    }
    document.getElementById('list1').innerHTML = html.join('');
}
if(isSupportFileApi()) {
    document.getElementById('file1').onchange = fileSelect1;
}
})();
</script>
</div>

### 拖拽

拖拽是另一种常见的文件访问场景，这种方式通过一个叫`dataTransfer`的接口来获得拖拽的文件列表，更多关于[dataTransfer](http://www.w3.org/TR/2011/WD-html5-20110113/dnd.html#the-datatransfer-interface)。

拖拽同样支持多选，用户可以拖拽多个文件。

```javascript
function dropHandler(e) {
    e.stopPropagation();
    e.preventDefault();

    var files = e.dataTransfer.files;
    for(var i = 0, len = files.length; i < len; i++) {
        var f = files[i];
        html.push(
            '<p>',
                f.name + '(' + (f.type || "n/a") + ')' + ' - ' + f.size + 'bytes',
            '</p>'
        );
    }
    document.getElementById('list2').innerHTML = html.join('');
}
function dragOverHandler(e) {
    e.stopPropagation();
    e.preventDefault();
    e.dataTransfer.dragEffect = 'copy';
}
var drag = document.getElementById('drag');
drag.addEventListener('drop', dropHandler, false);
drag.addEventListener('dragover', dragOverHandler, false);
```

运行此示例：

<div class="example">
<div id="drag" style="font-size:20px;padding:25px;border:1px dashed #666;text-align:center;color:#bbb;margin-bottom:10px">将文件拖到此处</div>
<div id="list2"></div>
<script type="text/javascript">
(function() {
var html = [];
function dropHandler(e) {
    e.stopPropagation();
    e.preventDefault();

    var files = e.dataTransfer.files;
    for(var i = 0, len = files.length; i < len; i++) {
        var f = files[i];
        html.push(
            '<p>',
                f.name + '(' + (f.type || "n/a") + ')' + ' - ' + f.size + 'bytes',
            '</p>'
        );
    }
    document.getElementById('list2').innerHTML = html.join('');
}
function dragOverHandler(e) {
    e.stopPropagation();
    e.preventDefault();
    e.dataTransfer.dragEffect = 'copy';
}
if(isSupportFileApi()) {
    var drag = document.getElementById('drag');
    drag.addEventListener('drop', dropHandler, false);
    drag.addEventListener('dragover', dragOverHandler, false);
}
})();
</script>
</div>

_PS:
拖拽有个特别需要注意的事情就是，阻止事件冒泡和事件默认行为，防止浏览器自动打开文件等行为，比如拖拽一个pdf，浏览器可能会打开pdf。_

至此，我们知道，我们可以通过两种方式来获得文件句柄，那么如何读取文件内容呢？

## 读取文件

HTML5提供了一个叫`FileReader`的接口，用于异步读取文件内容，它主要定义了以下几个方法：

* `readAsBinaryString(File|Blob)`
* `readAsText(File|Blob [, encoding])`
* `readAsDataURL(File|Blob)`
* `readAsArrayBuffer(File|Blob)`

`FileReader`还提供以下事件：

* onloadstart
* onprogress
* onload
* onabort
* onerror
* onloadend

一旦调用了以上某个方法读取文件后，我们可以监听以上任何一个事件来获得进度、结果等。

#### 预览本地图片

这里主要用到FileReader的`readAsDataURL`方法，通过将图片数据读取成Data URI的方法，将图片展示出来。

```javascript
function fileSelect2(e) {
    e = e || window.event;
    var files = this.files;
    var p = document.getElementById('preview2');

    for(var i = 0, f; f = files[i]; i++) {
        var reader = new FileReader();
        reader.onload = (function(file) {
            return function(e) {
                var span = document.createElement('span');
                span.innerHTML = '<img style="padding: 0 10px;" width="100" src="'+ this.result +'" alt="'+ file.name +'" />';

                p.insertBefore(span, null);
            };
        })(f);
        //读取文件内容
        reader.readAsDataURL(f);
    }
}
document.getElementById('files2').addEventListener('change', fileSelect2, false);
```

运行此示例：

<div class="example">
<p><input type="file" id="files2" accept="image/*" multiple  /></p>   
<div id="preview2"></div>
<script type="text/javascript">
(function() {
    function fileSelect2(e) {
        e = e || window.event;
        var files = this.files;
        var p = document.getElementById('preview2');

        for(var i = 0, f; f = files[i]; i++) {
            var reader = new FileReader();
            reader.onload = (function(file) {
                return function(e) {
                    var span = document.createElement('span');
                    span.innerHTML = '<img style="padding: 0 10px;" width="100" src="'+ this.result +'" alt="'+ file.name +'" />';

                    p.insertBefore(span, null);
                };
            })(f);
            //读取文件内容
            reader.readAsDataURL(f);
        }
    }
    if(isSupportFileApi()) {
        document.getElementById('files2').addEventListener('change', fileSelect2, false);
    }
})();
</script>
</div>

调用FileReader的readAsDataURL接口时，浏览器将异步读取文件内容，通过给FileReader实例监听一个onload事件，数据加载完毕后，在onload事件处理中，通过reader的result属性即可获得文件内容。

#### 预览文本文件

这里主要用到FileReader的`readAsText`，对于诸如mimeType为text/plain、text/html等文件均认为是文本文件，即mineType为text开头都可以用这个方法来预览。

```javascript
function fileSelect3(e) {
    e = e || window.event;

    var files = this.files;
    var p = document.getElementById('preview3');

    for(var i = 0, f; f = files[i]; i++) {
        var reader = new FileReader();
        reader.onload = (function(file) {
            return function(e) {
                var div = document.createElement('div');
                div.className = "text"
                div.innerHTML = encodeHTML(this.result);

                p.insertBefore(div, null);
            };
        })(f);
        //读取文件内容
        reader.readAsText(f);
    }
}
document.getElementById('files3').addEventListener('change', fileSelect3, false);
```

运行此示例：

<div class="example">
<input type="file" id="files3" accept="text/*" multiple />
<div id="preview3"></div>
<script type="text/javascript">
(function() {
function encodeHTML(source) {
    return source
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/, '&quote;')
            .replace(/'/, '&#39;');
};
function fileSelect3(e) {
    e = e || window.event;

    var files = this.files;
    var p = document.getElementById('preview3');

    for(var i = 0, f; f = files[i]; i++) {
        var reader = new FileReader();
        reader.onload = (function(file) {
            return function(e) {
                var div = document.createElement('div');
                div.className = "text"
                div.innerHTML = encodeHTML(this.result);

                p.insertBefore(div, null);
            };
        })(f);
        //读取文件内容
        reader.readAsText(f);
    }
}
if(isSupportFileApi()) {
    document.getElementById('files3').addEventListener('change', fileSelect3, false);
}
})();
</script>
</div>

_PS：由于需要在页面上预览文本，所以则需要对文件中的html特殊字符进行实体编码，避免浏览器解析文件中的html代码。_

#### 监控读取进度

既然FileReader是异步读取文件内容，那么就应该可以监听它的读取进度。

事实上，FileReader的onloadstart以及onprogress等事件，可以用来监听FileReader的读取进度。

在onprogress的事件处理器中，有一个ProgressEvent对象，这个事件对象实际上继承了Event对象，提供了三个只读属性：

* `lengthComputable`
* `loaded`
* `total`

通过以上几个属性，即可实时显示读取进度，不过需要注意的是，此处的进度条是针对单次读取的进度，即一次`readAsBinaryString`等方法的读取进度。

```javascript
var input4 = document.getElementById('file4');
var bar = document.getElementById('progress-bar');
var progress = document.getElementById('progress');
function startHandler(e) {
    bar.style.display = 'block';
}
function progressHandler(e) {
    var percentLoaded = Math.round((e.loaded / e.total) * 100);
    if (percentLoaded < 100) {
        progress.style.width = percentLoaded + '%';
        progress.textContent = percentLoaded + '%';
    }
}
function loadHandler(e) {
    progress.textContent = '100%';
    progress.style.width = '100%';
}
function fileSelect4(e) {
    var file = this.files[0];
    if(!file) {
        alert('请选择文件！');
        return false;
    }
    if(file.size > 500 * 1024 * 1024) {
        alert('文件太大，请选择500M以下文件，防止浏览器崩溃！');
        return false;
    }
    progress.style.width = '0%';
    progress.textContent = '0%';
    var reader = new FileReader();
    reader.onloadstart = startHandler;
    reader.onprogress = progressHandler;
    reader.onload = loadHandler;
    reader.readAsBinaryString(this.files[0]);
}
input4.onchange = fileSelect4;
```

运行此示例：

<div class="example">
<p><input id="file4" type="file" /></p>
<div id="progress-bar" style="border:1px solid #333;padding:5px;color:#fff;display:none;">
    <div style="width:0%;height:100%;background:blue;white-space:nowrap;" id="progress"></div>
</div>
<script type="text/javascript">
(function() {
var input4 = document.getElementById('file4');
var bar = document.getElementById('progress-bar');
var progress = document.getElementById('progress');
function startHandler(e) {
    bar.style.display = 'block';
}
function progressHandler(e) {
    var percentLoaded = Math.round((e.loaded / e.total) * 100);
    if (percentLoaded < 100) {
        progress.style.width = percentLoaded + '%';
        progress.textContent = percentLoaded + '%';
    }
}
function loadHandler(e) {
    progress.textContent = '100%';
    progress.style.width = '100%';
}
function fileSelect4(e) {
    var file = this.files[0];
    if(!file) {
        alert('请选择文件！');
        return false;
    }
    if(file.size > 500 * 1024 * 1024) {
        alert('文件太大，请选择500M以下文件，防止浏览器崩溃！');
        return false;
    }
    progress.style.width = '0%';
    progress.textContent = '0%';
    var reader = new FileReader();
    reader.onloadstart = startHandler;
    reader.onprogress = progressHandler;
    reader.onload = loadHandler;
    reader.readAsBinaryString(file);
}
if(isSupportFileApi()) {
    input4.onchange = fileSelect4;
}
})();
</script>
</div>


## 分割文件

有的时候，一次性将一个大文件读入内存，并不是一个很好的选择（如果文件太大，可能直接导致浏览器崩溃），上述的监听进度示例就有可能在文件太大的情况下崩溃。 

更稳健的方法是分段读取！

### 分段读取文件

HTML5 File Api提供了一个`slice`方法，允许分片读取文件内容。

```javascript
function readBlob(start, end) {
    var files = document.getElementById('file5').files;

    if(!files.length) {
        alert('请选择文件');
        return false;
    }

    var file = files[0],
        start = parseInt(start, 10) || 0,
        end = parseInt(end, 10) || (file.size - 1);

    var r = document.getElementById('range'),
        c = document.getElementById('content');

    var reader = new FileReader();
    reader.onloadend = function(e) {
        if(this.readyState == FileReader.DONE) {
            c.textContent = this.result;
            r.textContent = "Read bytes: " + (start + 1) + " - " + (end + 1) + " of " + file.size + " bytes";
        }
    };

    var blob;
    if(file.webkitSlice) {
        blob = file.webkitSlice(start, end + 1);
    } else if(file.mozSlice) {
        blob = file.mozSlice(start, end + 1);
    } else if(file.slice) {
        blob = file.slice(start, end + 1);
    }

    reader.readAsBinaryString(blob);
};
document.getElementById('file5').onchange = function() {
    readBlob(10, 100);
}
```

运行此示例：（读取10 ~ 100字节）

<div class="example">
<input type="file" id="file5" />
<div id="range"></div>
<div id="content"></div>
<script type="text/javascript">
(function() {
function readBlob(start, end) {
    var files = document.getElementById('file5').files;

    if(!files.length) {
        alert('请选择文件');
        return false;
    }

    var file = files[0],
        start = parseInt(start, 10) || 0,
        end = parseInt(end, 10) || (file.size - 1);

    var r = document.getElementById('range'),
        c = document.getElementById('content');

    var reader = new FileReader();
    reader.onloadend = function(e) {
        if(this.readyState == FileReader.DONE) {
            c.textContent = this.result;
            r.textContent = "Read bytes: " + (start + 1) + " - " + (end + 1) + " of " + file.size + " bytes";
        }
    };

    var blob;
    if(file.webkitSlice) {
        blob = file.webkitSlice(start, end + 1);
    } else if(file.mozSlice) {
        blob = file.mozSlice(start, end + 1);
    } else if(file.slice) {
        blob = file.slice(start, end + 1);
    }

    reader.readAsBinaryString(blob);
};
if(isSupportFileApi()) {
    document.getElementById('file5').onchange = function() {
        readBlob(10, 100);
    }
}
})();
</script>
</div>

本例使用了FileReader的onloadend事件来检测读取成功与否，如果用onloadend则必须检测一下FileReader的readyState，因为read abort时也会触发onloadend事件，如果我们采用onload，则可以不用检测readyState。

### 分段读取进度

那分段读取一个大文件时，如何监控整个文件的读取进度呢？

这种情况下，因为我们调用了多次FileReader的文件读取方法，跟上文一次性把一个文件读到内存中的情况不大相同，不能用onprogress来监控。

我们可以监听onload事件，每次onload代表每个片段读取完毕，我们只需要在onload中计算已读取的百分比就可以了！

```javascript
var bar2 = document.getElementById('progress-bar2');
var progress2 = document.getElementById('progress2');
var input6 = document.getElementById('file6');
var block = 1 * 1024 * 1024; // 每次读取1M
// 当前文件对象
var file;
// 当前已读取大小
var fileLoaded;
// 文件总大小
var fileSize;

// 每次读取一个block
function readBlob2() {
    var blob;
    if(file.webkitSlice) {
        blob = file.webkitSlice(fileLoaded, fileLoaded + block + 1);
    } else if(file.mozSlice) {
        blob = file.mozSlice(fileLoaded, fileLoaded + block + 1);
    } else if(file.slice) {
        blob = file.slice(fileLoaded, fileLoaded + block + 1);
    } else {
        alert('不支持分段读取！');
        return false;
    }
    reader.readAsBinaryString(blob);
}
// 每个blob读取完毕时调用
function loadHandler2(e) {
   fileLoaded += e.total;
   var percent = fileLoaded / fileSize;
   if(percent < 1)  {
       // 继续读取下一块
       readBlob2();
   } else {
       // 结束
       percent = 1;
   }
   percent = Math.ceil(percent * 100) + '%';
   progress2.innerHTML = percent;
   progress2.style.width = percent;
}
function fileSelect6(e) {
    file = this.files[0];
    if(!file) {
        alert('文件不能为空！');
        return false;
    }
    fileLoaded = 0;
    fileSize = file.size;
    bar2.style.display = 'block';
    // 开始读取
    readBlob2();
}
var reader = new FileReader();
// 只需监听onload事件
reader.onload = loadHandler2;
input6.onchange = fileSelect6
```

运行此示例：（提示：请选择一个1G以上文件）

<div class="example">
<p><input type="file" id="file6" /></p>
<div id="progress-bar2" style="border:1px solid #333;padding:5px;color:#fff;display:none;">
    <div style="width:0%;height:100%;background:blue;white-space:nowrap;" id="progress2"></div>
</div>
<script type="text/javascript">
(function() {
var bar2 = document.getElementById('progress-bar2');
var progress2 = document.getElementById('progress2');
var input6 = document.getElementById('file6');
var block = 1 * 1024 * 1024; // 1M
var file;
var fileLoaded;
var fileSize;

function readBlob2() {
    var blob;
    if(file.webkitSlice) {
        blob = file.webkitSlice(fileLoaded, fileLoaded + block + 1);
    } else if(file.mozSlice) {
        blob = file.mozSlice(fileLoaded, fileLoaded + block + 1);
    } else if(file.slice) {
        blob = file.slice(fileLoaded, fileLoaded + block + 1);
    } else {
        alert('不支持分段读取！');
        return false;
    }
    reader.readAsBinaryString(blob);
}
function loadHandler2(e) {
   fileLoaded += e.total;
   var percent = fileLoaded / fileSize;
   if(percent < 1)  {
       // 继续读取下一块
       readBlob2();
   } else {
       // 结束
       percent = 1;
   }
   percent = Math.ceil(percent * 100) + '%';
   progress2.innerHTML = percent;
   progress2.style.width = percent;
}
function fileSelect6(e) {
    file = this.files[0];
    if(!file) {
        alert('文件不能为空！');
        return false;
    }
    fileLoaded = 0;
    fileSize = file.size;
    bar2.style.display = 'block';
    readBlob2();
}
if(isSupportFileApi()) {
    var reader = new FileReader();
    reader.onload = loadHandler2;
    input6.onchange = fileSelect6
}
})();
</script>
</div>

## 注意事项

在chrome浏览器上测试时，如果直接以file://xxx这种形式访问demo，会出现FileReader读取不到内容的情况，表现为FileReader的result为空或者FileReader根本就没有去读取文件内容，FileReader各个事件没有触发；

这种情况我想应该是类似于chrome不允许添加本地cookie那样，chrome也不允许以file://xxx这种页面上的js代码访问文件内容；

解决办法很简单，只需要将测试文件放到一个web服务器上，以http://xxx形式访问即可。

## 参考文章

* http://www.html5rocks.com/en/tutorials/file/dndfiles/
