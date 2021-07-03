---
title: "启动时以root身份运行脚本"
date: 2020-03-30T14:16:32+08:00
lastmod: 2020-03-30T14:16:32+08:00
draft: true
keywords: ["Linux"]
description: ""
tags: []
categories: ["Linux"]
author: "gina"

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



如果需要以当前用户身份运行程序, 请出我们的crontab

作为一款定时任务执行工具, 重启时的脚本运行, 是他功能中的一个(定时任务执行)

```bash
crontab -e # 不要加sudo, 是当前用户的身份
# 进入编辑器模式后
@reboot {exec directory}
```

