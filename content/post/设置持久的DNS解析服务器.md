---
title: "设置持久的DNS解析服务器"
date: 2020-06-16T03:06:29+08:00
lastmod: 2020-06-16T03:06:29+08:00
draft: false
keywords: ["DNS解析"]
description: ""
tags: []
categories: ["Linux"]
author: "leo"

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
# Linux设置持久的DNS解析服务器
首先, 安装resolvconf, 这个包可以在每次启动的时候, 修改/etc/resolv.conf文件, 持久化用户的nameserver设置
```bash
sudo apt update
sudo apt install resolvconf
nano /etc/resolvconf/resolv.conf.d/head # add nameserver 119.29.29.29
sudo systemctl restart resolvconf.service # Then logout and login
```