---
title: "V2ray翻墙方案(v2ray+tls+webServer+docker+中转)"
date: 2021-05-18T23:11:01+08:00
lastmod: 2021-05-18T23:11:01+08:00
draft: false
keywords: ["VPS"]
description: ""
tags: ["v2ray", "Linux"]
categories: ["GFW"]
author: "leo2n"

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
目前, 主流的翻墙方式有两种, 一种是加密, 一种是伪装

加密的方式, 稍微接触过一点翻墙的人, 应该都非常熟悉, 例如: vmess on v2ray 就是一种加密方式, 但是缺点是流量没有特征, 容易被GFW封禁. 为什么呢? 因为没有特征其实就是最大的特征, 什么人会用完全没有特征的流量呢? 嘿嘿~

最好的方式其实是将自己藏匿于人群中, 你可以使用明面上的https流量, 域名指向你的网站, 但是, 接收到你的请求的web服务器会从你的请求path中判断, 你到底是想要查看自己的网站, 还是想访问特定的web app,  如果是第一种,  就访问站点应用, 如果是第二种, 那就访问你的v2ray应用.

​	
