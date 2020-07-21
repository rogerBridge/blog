---
title: "URL之加斜杠和不加斜杠"
date: 2020-06-13T22:57:42+08:00
lastmod: 2020-06-13T22:57:42+08:00
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
# URL之到底加不加斜杠呢？
实际上url加斜杠和不加斜杠是两个不同的东西，比如：
`/process` 和 `/process/` 在服务器的眼中，你访问的是两个不同的地址, 使用习惯上来说，加/的代表这个url定位的是一个目录资源，它应该还包含一些文件，或者加/的是一个接口集合，它应该还包含一些子接口， 比如`/user/` 就可能有`/user/login`, `/user/register`, `/user/logout` 等等，是否加斜杠取决于你的URL的目的, 如果是一串子接口的集合, 那就加, 如果不是呢? 那就别加了