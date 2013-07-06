---
layout: post
title: "bower添加completion支持"
description: ""
---

[bower](http://bower.io/)是twitter开发的一个web前端包管理器，使用它可以很方便的管理前端资源，比如我现在需要jquery，按照以前的做法，是上jquery官网去下载，但是现在可以用一行命令就搞定。

```bash
bower install jquery
```

这样就可以很简单地拿到所需要的jquery文件。

bower提供的功能很多，支持`search`、`init`、`link`等，具体详解bower官网。

安装`bower`的时候，并不支持tab
completion，那怎么办？在命令行上直接执行`bower`看看：

     Usage:

        bower <command> [<args>] [<options>]

    Commands:

        cache-clean    Clean the Bower cache, or the specified package caches
        completion     Tab Completion for Bower
        help           Display help information about Bower
        info           Version info and description of a particular package
        init           Interactively create a bower.json file
        install        Install a package locally
        link           Symlink a package folder
        list, ls       List all installed packages
        lookup         Look up a package URL by name
        register       Register a package
        search         Search for a package by name
        uninstall      Remove a package
        update         Update a package

    Options:

        --no-color - Do not print colors (available in all commands)
       --quiet    - Suppress all output except for warnings and errors (available in all commands)
        --silent   - Suppress all output (available in all commands)

    See 'bower help <command>' for more information on a specific command.

看到其中的`completion`顿时来了精神，再在命令行下执行:

    bower completion

看一下输出的内容：

    ###-begin-bower-completion-###
    #
    # Installation: bower completion >> ~/.bashrc  (or ~/.zshrc)
    # Or, maybe: bower completion > /usr/local/etc/bash_completion.d/bower
    #

哈哈，走到这里，都应该知道怎么添加tab completion支持了吧！！！

_注意：在mac osx上应该添加到`~/.bash_profile`文件中。_
