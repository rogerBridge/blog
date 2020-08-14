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

```bash
# type ecdsa -b(bit length) 521 bit
ssh-keygen -t ecdsa -b 521
```

然后, 将生成的文件添加到远程机器的authorized_keys文件下

```shel
cat ~/.ssh/id_rsa.pub | ssh a@A 'cat >> .ssh/authorized_keys'
```

或者

```bash
ssh-copy-id -i [public key file path] [userName]@[hostAddress]
```

配置完成后, SSH登录远程机器就不用输入密码啦!