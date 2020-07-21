---
title: "Ssh登录远程机器且不用密码"
date: 2020-03-30T21:16:44+08:00
lastmod: 2020-03-30T21:16:44+08:00
draft: false
keywords: []
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
# SSH登录远程机器且不用密码登录的方式

首先, 创建一个公钥秘钥对

`ssh-keygen -t ecdsa -b 521 # ecdsa 通常更安全+体积小`

然后, 将生成的文件添加到远程机器的authorized_keys文件下

`cat ~/.ssh/id_rsa.pub | ssh a@A 'cat >> .ssh/authorized_keys'`

或者

`ssh-copy-id -i ~/.ssh/id_rsa.pub a@A`

Finally, ssh登录远程机器就不用输入密码啦~