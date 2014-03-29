---
layout: post
title: "如何实现一个动画库"
categories:
    - 
tags:
    - js
    - animation
    - 动画库
description: ""
---

原生js做动画？我们都知道最简单的方式就是用`setInterval/setTimeout`来不断地调用某个绘制函数，比如：

```javascript
var interval = null;
var button = document.getElementById('test');
var end = 500;
function step() {
    var w = parseInt(button.style.width, 10);
    var v = Math.min(w + 10, end);
    button.style.width = w + 10 + 'px';
    if(v >= end) {
        clearInterval(interval);
    }
}
function start() {
    interval = setInterval(step, 1000/ 60);
}
button.onclick = start;
```

运行此示例：

<!-- more -->

<div class="example">
    <button id="test" style="width: 100px">test</button>
    <script type="text/javascript">
        var interval = null;
        var button = document.getElementById('test');
        var end = 500;
        function step() {
            var w = parseInt(button.style.width, 10);
            var v = Math.min(w + 10, end);
            button.style.width = w + 10 + 'px';
            if(v >= end) {
                clearInterval(interval);
            }
        }
        function start() {
             interval = setInterval(step, 1000/ 60);
        }
        button.onclick = start;
    </script>
</div>

但是这种实现方法并不具备一般性，比如不好应用线性、淡入、淡出等缓动函数，更具一般性的动画应该具备以下元素：

* 帧率，`fps`，理想状态下，该值应该接近于屏幕刷新频率`60HZ`
* 动画持续时间，`duration`
* 动画开始时间，`startTime`
* 动画已花费时间，`passedTime`
* 已花费时间百分比，`percent`，取值范围`0~1`
* 缓动函数，`delta = easing(percent)`，通常在这一步中，我们可以应用一些函数来改变动画的变化效果，比如由慢到快或者由快到慢等等
* 重绘dom元素，`step(delta)`

例如：

```javascript
function animate(options) {
    var startTime = +new Date;

    var interval = setInterval(
        function() {
            var passedTime = +new Date() - startTime;
            var percent = passedTime / options.duration;

            if(percent > 1) {
                percent = 1;
            }
            var delta = options.easing(percent);

            options.step(delta);

            if(percent == 1) {
                clearInterval(interval);
            }
        },
        1000 / (options.fps || 60)
    );
}

// 示例
function move() {
    var from = parseInt(button2.style.width, 10);
    var to = 500;
    animate({
        duration: 400,
        fps: 60,
        easing: function(percent) { 
            // 这里就简单地以"线性变化"来演示
            // 你可以改成其他缓动函数试试
            return  percent;
        },
        step: function(delta) {
            button2.style.width = from + (to - from) * delta + 'px';
        }
    });
}
button2.onclick = move;
```
运行此示例：

<div class="example">
    <button id="test2" style="width:100px;">test2</button>
    <script type="text/javascript">
        // 动画库雏形
        function animate(options) {
            var startTime = +new Date;

            var interval = setInterval(
                function() {
                    var passedTime = +new Date() - startTime;
                    var percent = passedTime / options.duration;

                    if(percent > 1) {
                        percent = 1;
                    }
                    var delta = options.easing(percent);

                    options.step(delta);

                    if(percent == 1) {
                        clearInterval(interval);
                    }
                },
                1000 / (options.fps || 60)
            );
        }
        var button2 = document.getElementById('test2');

        button2.onclick = function() {
            var from = parseInt(button2.style.width, 10);
            var to = 500;
            animate({
                duration: 400,
                fps: 60,
                easing: function(percent) { 
                    // 这里就简单地以"线性变化"来演示
                    // 你可以改成其他缓动函数试试
                    return  percent;
                },
                step: function(delta) {
                    button2.style.width = from + (to - from) * delta + 'px';
                }
            });
        }
    </script>
</div>

ok，到此我们就完成了一个动画库的雏形，在实际应用中，还有不少细节需要完成，比如动画队列、自动计算初始样式值等。
