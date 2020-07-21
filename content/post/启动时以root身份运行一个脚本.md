---
title: "启动时以root身份运行脚本"
date: 2020-03-30T14:16:32+08:00
lastmod: 2020-03-30T14:16:32+08:00
draft: false
keywords: ["Linux"]
description: ""
tags: []
categories: ["Linux"]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: false
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
---
<!--more-->
# 在开机启动时以root身份执行脚本

请出我们的systemd service

创建文件 `/etc/systemd/system/{serverName}.service`

```
[Unit]
Description=describe what you want to do using this scripts

[Service]
ExecStart=/path/to/yourscript.sh

[Install]
WantedBy=multi-user.target
```

创建待执行的脚本: yourscript.sh

```bash
#!/usr/bin/bash
echo "A ha~"
```
记得 `chmod u+x yourscript.sh`

然后激活你的服务
`systemctl enable {serverName}.service`