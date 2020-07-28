---
title: "持久化linux最大文件打开数"
date: 2020-07-27T21:41:50+08:00
lastmod: 2020-07-27T21:41:50+08:00
draft: false
keywords: []
description: ""
tags: []
categories: []
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

```bash
sudo nano /etc/sysctl.conf
fs.file_max = 102400

sudo nano /etc/security/limits.conf
# add following lines to it
* soft        nproc          102400   
* hard        nproc          102400 
* soft        nofile         102400 
* hard        nofile         102400
root soft     nproc          102400  
root hard     nproc          102400   
root soft     nofile         102400 
root hard     nofile         102400

# Then
sudo nano /etc/pam.d/common-session
# add line below
session required pam_limits.so
```
