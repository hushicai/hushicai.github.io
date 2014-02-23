---
layout: post
title: "gem安装compass问题"
description: ""
---

最近想玩玩[compass](http://compass-style.org/install/)，所以就试了一把，按照官网的说明，先安装compass：

```bash
gem update --system && gem install compass
```

安装完成后，却发现找不到compass命令（系统是mac os x 10.9）。

这问题应该是gem把compass安装到了一个不在PATH中的目录所导致的，于是就开始了以下排查过程：

```bash
which ruby
```

我的是安装在`/usr/local/bin/ruby`，进到该目录上：

```bash
ll | grep ruby
```

找到`ruby`的原始安装目录：

    ruby -> ../Cellar/ruby/2.0.0-p195/bin/ruby

进入到以上目录后，发现同目录下有个`compass`，而这个目录并不在PATH上，于是就出现了：

    compass not found

很显然，造成这个问题的原因就是因为：`ruby`是通过`brew`安装的，而`brew`安装`ruby`的实际目录并不在PATH上。

所以，为了让compass命令可用，我们需要手工建立一个softlink：

```bash
hushicai: /usr/local/bin $ ln -s ../Cellar/ruby/2.0.0-p195/bin/compass compass
```

搞定！
