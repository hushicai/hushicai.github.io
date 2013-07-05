---
layout: post
title: "function declarations within blocks"
description: ""
---

在google javascript style guide上有这么一条规则: [function declarations within
blocks](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml?showone=Function_Declarations_Within_Blocks#Function_Declarations_Within_Blocks).

google建议不要这么写：

```javascript
if(x) {
    function foo() {}   
 }
```

为什么呢？这涉及到`function declarations`与`function expressions`的问题。

### 什么是function declarations

`ecma-262`对`function declarations`的定义如下：

```javascript
function Identifier ( FormalParameterListopt ) { FunctionBody }
```

`function declarations`具备以下几个特征：

* **Identifier**必不可少

* Function declarations cannot be nested within non-function blocks, such as if.

* Function Declarations must begin with **function**

* The function name is visible within it’s scope and the scope of it’s parent.

代码示例如下：

```javascript
function bar() {
    return 3;    
}
bar(); // 3
```
<!-- more -->

### 什么是function expressions

`ecma-262`对`function expressions`的定义如下：

```javascript
function Identifieropt ( FormalParameterListopt ) { FunctionBody }
```

`function expressions`具备了以下几个特征：

* Identifier是可选的

* 通常是在一个变量声明语句中

* 通过`function expressions`定义的`function`可以是具名的，也可以是匿名的

* `function expressions`通常不能以`function`开头

代码示例如下：

```javascript
// 匿名
var a = funciton() {
    return 3;    
}

// 具名
var a = function bar() {
    return 3;    
}

// self invoking function expressions
(function bar() {
    return 3;    
})();
```

对于`function expressions`有一个特别需要的注意的事就是`named function
expressions`.

以下函数定义就是一个`named function expressions`:

```javascript
var test = function bar() {
    return 3;
}

console.log(bar);  // undefined
```

`named function expressions`的`function name`只能在它的function
body中可见，而在当前scope下是不可见的，如上例所示，`console.log(bar)`是`undefined`。

### function declarations与function expressions的区别

我们知道，javascript控制器在转入可执行脚本时，控制器会进入一个执行环境，然后进行[定义绑定初始化](http://ecmascript.cn/#151)。在这里我们就不多说定义绑定初始化，有兴趣的同学可以自行研读`ecma-262`，我们挑重点的讲：

* 绑定`function declarations`

* 绑定`variable declarations`

`function
declarations`会被控制器提前解析，也就是我们通常所讲的**预编译**，而`function
expressions`则按顺序执行。

### 小结

那么文章开头的那段代码中，`function foo() {}`到底是function
declarations呢？还是function expressions？事实上，我们可以把它叫做**function
statement**

什么是function statement？

>Its sometimes just a pseudonym for a Function Declaration.  
>In mozilla a Function Statement is an extension of Function
>Declaration allowing the Function Declaration syntax to be used anywhere a
>statement is allowed.  It’s as yet non standard so not recommended for
>production development.

综上，我们知道，有的浏览器会把文章开头的那段代码当做`function
expressions`，这时那个if逻辑永远不会进入，`foo`肯定是undefined；但是有的浏览器却会把它解析为`function
declarations`，这时`foo`会在**定义绑定初始化**的过程中，被提前声明，它在当前scope下是可用的。

实际上，它应该是一个expressions，所以，为了保证浏览器的兼容性,同时能符合`ecma-262`规范，正确的写法应该如下：

```javascript
if(x) {
    var foo = function() {}   
}
```

### 参考文章

* http://ecmascript.cn/#237

* http://javascriptweblog.wordpress.com/2010/07/06/function-declarations-vs-function-expressions/
