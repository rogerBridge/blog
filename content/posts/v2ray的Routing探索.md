---
title: "V2ray的Routing探索"
date: 2021-05-27T22:54:38+08:00
lastmod: 2021-05-27T22:54:38+08:00
draft: true
keywords: ["v2ray"]
description: ""
tags: ["科学上网"]
categories: ["科学上网"]
author: "leo2n"

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: true
toc: true
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: false
mathjaxEnableSingleDollar: false
mathjaxEnableAutoNumber: false

# You unlisted posts you might want not want the header or footer to show
hideHeaderAndFooter: false

# You can enable or disable out-of-date content warning for individual post.
# Comment this out to use the global config.
#enableOutdatedInfoWarning: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

<!--more-->

最近看了一下v2ray官方的文档, 越发感觉这个工具简直就像一个百宝箱, 不仅仅可以用作简单的代理, 还可以根据内在的Routing功能, 做到以下事情(前提是你要有: geosite.dat, geoip.dat 这两个数据文件或者自定义一个):

- 访问国内域名或者国内IP, 走直连
- 访问国外域名或者国外IP, 走代理
- 自定义域名(通过修改geosite.dat, geoip.dat文件的方式), 可以走直连, 也可以走代理

首先, 定义一下简单的inbounds和outbounds

## inbounds

首先, 看一个简单的inbounds(type: []Inbound, protocal: socks)实例:



```json
    {
      "listen": "0.0.0.0", // 如果你在本地设备上运行, 那么设置为0.0.0.0, 意味着局域网内的其他设备, 可以通过你的设备实现翻墙, 如果设置为127.0.0.1, 意味着只有本地设备上的应用可以翻墙; 如果你使用的是docker, 推荐你设置为0.0.0.0, 不然数据映射不出来的~
      "port": 10000, // 
      "protocol": "socks",
      "settings": {
        "userLevel": 0
      },
      "sniffing": {
        "destOverride": ["http", "tls"],
        "enabled": true
      },
      "tag": "socks"
    }
```



首先, 看一个简单的Routing 例子: 

```json
      {
        "type": "field", // 目前type只有field可以使用
        "inboundTag": ["socks", "http"], // 流量入口 
        "outboundTag": "direct",  // 流量出口(发送到你想要流量去的主机, 通常是可以翻墙的VPS, 或者是突破内网限制的VPS)
        "domain": ["geosite:geolocation-!cn"] // 匹配域名, 官方安装包自带: geosite.dat, geoip.dat, 如果你是使用docker安装的话, geosite.dat和geoip.dat一般存放在这个目录: /usr/local/share/v2ray, 具体可以看一下: 
      }
```



