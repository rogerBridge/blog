---
title: "SSH登录Ubuntu Server的设置方式"
date: 2020-03-30T21:16:44+08:00
lastmod: 2020-03-30T21:16:44+08:00
draft: false
keywords: ["SSH"]
description: "登录远程服务器的方式之一"
tags: ["SSH", "Linux"]
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

首先, 创建一个公钥秘钥对

```bash
# type ecdsa -b(bit length) 521 bit
# ECDSA 是一个较短bit产生高强度的公钥-私钥对的方式
ssh-keygen -t ecdsa -b 521
```

然后, 将生成的文件添加到远程机器的authorized_keys文件下

```shel
cat ~/.ssh/{{ name you generated }}.pub | ssh a@A 'cat >> .ssh/authorized_keys'
```

或者

```bash
ssh-copy-id -i [public key file path] [userName]@[hostAddress]:~/.ssh/
```

配置完成后, SSH登录远程机器就不用输入密码啦, 直接可以使用SSH方式连接

```bash
ssh {{username}}@{{host}} -i {{privKey}}
```

