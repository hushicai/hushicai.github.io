---
layout: post
title: "max os x dscl命令介绍"
description: ""
---

max os x提供了一个称为**Directory Service Command Line utility**的命令工具，终端下的命令为`dscl`，基本用法如下：

    dscl [options] [datasource [command]]

    options:
        -p           prompt for password
        -u user      authenticate as user
        -P password  authentication password
        -f filepath  targeted local node database file path
        -raw         don't strip off prefix from DirectoryService API constants
        -plist       print out record(s) or attribute(s) in XML plist format
        -url         print record attribute values in URL-style encoding
        -q           quiet - no interactive prompt

    commands:
        -read [path [key ...]]
        -readall [path [key ...]]
        -readpl path key plist_path
        -readpli path key value_index plist_path
        -list path [key]
        -search path key val
        -create record_path [key [val ...]]
        ...

    available only in interactive mode:
        -cd dir
        -pushd [dir]
        -popd
        -auth [user [password]]
        -authonly [user [password]]
        -quit

更多用法，请自行`man dscl`。

<!-- more -->

`dscl`中有两个东西需要弄明白：

* datasource 是什么东西？请仔细查看man文档，其中有这么一段介绍：

        dscl operates on a datasource specified on the command line.  
        This may be a node name or a Mac OS X Server (10.2 or later) host specified by DNS hostname or IP address. 
        Node names may be absolute paths beginning with a slash ("/"), or relative domain paths beginning with a dot (".") character, which specifies the local domain, or "..", specifying the local domain's parent.  
        If the hostname or IP address form is used then the user must specify the -u option and either the -P of -p options to specify an administrative user and password on the remote host to authenticate with to the remote host. 
        The exception to this is if "localhost" is specified. 

    _原来就是指网络上的主机，如果是本机（local domain），则用一个点“.”表示。_

* path又是指啥？同样也能在man文档中找到：

        There two modes of operation when specifying paths to operate on. The two modes correspond to whether the datasource is a node or a host. In the case of specifying a node, the top level of paths will be record types. Example top level paths would be:

               /Users/alice
               /Groups/admin

         In the case of specifying a host as a data source, the top level of paths correspond to Open Directory plug-ins and Search Paths. One can specify the plug-in to traverse to a node name, after which the paths are equivalent to the former usage. The following might be the equivalent paths as the above paths:

               /NetInfo/root/Users/alice
               /LDAPv3/10.0.1.42/Groups/admin

    _如果datasource是本机，则path指的就是资源类型（组或者用户）；如果是网络主机，则指的是dscl命令搜索的主机路径（这么描述可能不恰当）。_

它和mysql类似，可以有两种调用方式：

* 普通命令行方式

    ```bash
    hushicai: ~ $ dscl . -list /Groups | less
    ```

* 交互式

    ```bash
    hushicai: ~/data/github/hushicai.github.com $ dscl localhost
     >
    ```

    光标位于符号">"后面，可以使用交互命令进行相关操作，输入help可以查看更多命令。

我们可以使用`dscl`这个命令来管理mac os x上的用户权限，比如新增用户组、新增用户等！
