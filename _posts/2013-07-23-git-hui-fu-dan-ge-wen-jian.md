---
layout: post
title: "git恢复单个文件"
description: ""
---

如果还未commit，想恢复到remote repo上的最新文件，则可以这么干：

```bash
git checkout -- 文件路径
```

这样就会覆盖掉本地修改！
