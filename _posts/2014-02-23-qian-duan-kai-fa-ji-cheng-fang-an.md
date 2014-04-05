---
layout: post
title: "前端开发集成方案"
description: ""
---

在前端开发过程中，我们也许都会遇到这样的场景：

* 有新项目了？A: 赶紧搭起开发环境; B:去xx项目那边拷一份过来改改吧；
* 去哪下jquery 1.9.1版本啊？官网找半天没找着;
* 代码里面写多了个逗号，导致ie报错了？赶紧人肉查一下；
* 项目要上线了？赶紧想办法合并、压缩、加个版本号；
* ...

诸如此类的问题，老在做重复工作，太枯燥了...

come on，别忘了我们是程序员，重复的工作应该交给程序来干！

我们需要一种自动化的前端开发集成方案！

那么，前端开发集成方案应该具备什么功能呢？在我看来，它需要以下技能：

* 一个脚手架，用来自动生成项目的基础结构、生成一些基础代码等等。
* 一个build工具，用来执行各项自动化任务，比如语法检查、合并、压缩等
* 一个包管理器，用来导入一些基础库等

基于以上需求，我找到了一套叫[yeoman](http://yeoman.io)的解决方案，它包括了三方面：

* `yo`：脚手架工具
* `bower`：前端资源管理器
* `grunt`：任务型build工具

以上三个工具是独立维护的，它们可以很好地工作在一起，组成一套完整的前端开发集成方案。

## yo脚手架

[yo](https://github.com/yeoman/yo)是一个脚手架工具，安装它：

```bash
npm install -g yo
```

`yo`可以生成多种类型的项目/代码，但这需要依赖于[generators](http://yeoman.io/community-generators.html)，比如我们想生成一个web应用，我们需要先安装一下`generator-webapp`：

<!-- more -->

```bash
npm install -g generator-webapp
```

安装完generator后，我们就可以这样新建一个web应用：

```bash
yo webapp
```

执行完以上命令后，`yo`会自动生成一些基础目录/代码，还会使用npm自动安装依赖以及使用bower导入前端基础库。

如果你想找其他的generator，你可以这样：

```bash
npm search yeoman-generator
```

你可以得到一大堆开源的generator。当然你也可以自定义generator，建立一套自己的基础项目库，以后在新项目中，分分钟就可以完成基础环境搭建！

如何自定义generator，请看[这里>>](http://yeoman.io/generators.html)。

## bower

[bower](http://bower.io/)是一个前端资源包管理器，安装它：

```bash
npm install -g bower
```

`bower`是twitter开发的一个包管理器，它可以用来管理前端资源，让前端资源的使用更加容易。

假如我们现在想使用jquery，怎么用`bower`来导入到项目中呢？

我们可以先查询一下：

```bash
bower search jquery
```

通过查询，我们知道jquery就是它的包名称，这时，我们就这样来导入到项目中：

```bash
bower install jquery
```

这样就完成了基础库导入，但是导入的jquery版本号太新了：2.1.0（这个版本不适合web开发，它貌似不兼容ie了）。

这可能并不是我们想要的，我们想要一个合适的版本号，我们想知道jquery有多少版本可供选择：

```bash
bower info jquery
```

通过以上命令，我们可以找到好多jquery版本，我们选择一个我们常用的版本，比如1.9.1：

```bash
bower install jquery#1.9.1
```

当然在更换版本的时候，我们需要先删掉之前安装的版本（否则会提示版本冲突，bower会让我们选择其中一个）：

```bash
bower prune jquery
```

`bower`通过一个叫`bower.json`的文件来管理资源的，它还有另外一个配置文件`.bowerrc`文件，用来配置资源的存放路径等。

更多用法，可以参考[官网文档](http://bower.io)。

## grunt

[grunt](http://gruntjs.com)是目前社区很火的一个build工具，它可以通过配置一系列任务来部署、预览、测试一个项目，安装它：

```bash
npm install -g grunt-cli
```

上面只是安装了`grunt`命令，还没安装`Grunt Task Runner`，需要到项目根目录上再安装一下`Grunt Library`：

```bash
npm install grunt --save-dev
```

运行`grunt`时，它会通过`require`方法来找到`Grunt Library`，然后读取`Gruntfile`配置文件执行指定的任务。

使用`grunt`时，需要有两个必不可少的配置文件：

* `package.json`
* `gruntfile.js`

项目根目录下，必须要有这两文件。

通常我们可以通过上文介绍的`yo`来自动生成以上两个文件（文件中包含一些常用的配置），比如：

```javascript
// package.json example:
{
  "name": "my-project-name",
  "version": "0.1.0",
  "devDependencies": {
    "grunt": "~0.4.2",
    "grunt-contrib-uglify": "~0.2.2"
  }
}

// gruntfile.js example:
module.exports = function(grunt) {
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      build: {
        src: 'src/<%= pkg.name %>.js',
        dest: 'build/<%= pkg.name %>.min.js'
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');

  // Default task(s).
  grunt.registerTask('default', ['uglify']);
};
```

接下来就是要寻找或者自定义`gruntplugins`：

* [这里](http://gruntjs.com/plugins)可以查，当然也可以去github上找。
* 自定义`gruntplugin`可以参考[这里](http://gruntjs.com/creating-plugins)。

找到一个合适的plugin后，可以这么引用：

```bash
npm install pluginname --save-dev
```

安装完plugin之后，就需要到`gruntfile.js`中做一些配置了，具体配置参见各个plugin的文档。

一切就绪后，执行相关任务就ok了！

## 小结

有了此类前端开发集成方案，开发效率肯定会提高很多！
