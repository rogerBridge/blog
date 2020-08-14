---
title: "搭建Trojan科学上网节点"
date: 2020-03-30T14:07:23+08:00
lastmod: 2020-03-30T14:07:23+08:00
draft: false
keywords: []
description: ""
tags: []
categories: ["科学上网"]
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

+ trojan是什么?

  trojan是一款科学上网工具

+ trojan的工作原理是什么?

  trojan服务端接收请求, 一旦发现请求来自浏览器, 就会将请求转发到Nginx, 模拟HTTPS情况下的web服务器. 如果发现进来的请求来自trojan客户端, 那就正常进行科学上网的操作.

+ 如何配置trojan?

  下载trojan编译好的包. 下载地址: 点我下载

* 准备一个http服务器, Ubuntu下, 直接: sudo apt install nginx 就阔以啦😁

* 搞个域名, 将域名解析到自己的VPS上.

* 搞个证书, 最好嘛, 申请一个真正的证书, 装就装到底呗~ 😎

```bash
  certbot certonly # 直接获取到一个服务器和客户端的证书对
  tar xf trojan.tar.xz
  cd trojan # examples目录下有一个server.json-example, 直接拷贝到上层目录, 并且改名为: config.json 一般只需要更改password字段和ssl字段就阔以了
```

客户端配置, 运行

```bash
cp server.json-example ../config.json
# 更改: local_port, remote_addr, remote_port, password, ssl 注意, 因为我们都使用的是真正的证书, 所以, ssl项里面, "verify": true, "verify_hostname": true, 真正的证书, 真正的域名, 都填true
```