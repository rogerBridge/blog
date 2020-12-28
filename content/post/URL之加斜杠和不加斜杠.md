---

title: "URL加斜杠与不加斜杠"
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

实际上url加斜杠和不加斜杠是两个不同的东西，比如：

请求的URL: `/process` 和 `/process/`,  在接收端看来，你访问的是两个不同的地址, 使用习惯上来说，加/的代表这个url定位的是一个集合，它应该包含一些子类, 例如: `/user/`,  它或许是: `/user/register`, 或许是: `/user/login`, `/user/recharge`，是否加斜杠取决于你的URL的目的, 如果是一串子接口的集合, 那就加, 如果只是一个单一的动作或者接口, 例如: `/search`, `/query`, 那就别加了呗 👀