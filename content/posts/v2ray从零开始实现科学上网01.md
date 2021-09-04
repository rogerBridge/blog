---
title: "V2ray从零开始实现科学上网01: 编写配置文件"
subtitle: ""
date: 2021-07-17T21:55:28+08:00
lastmod: 2021-07-17T21:55:28+08:00
draft: false
author: "gina"
authorLink: ""
description: ""

tags: ["v2ray", "Linux"]
categories: ["GFW"]

hiddenFromHomePage: false
hiddenFromSearch: false

featuredImage: ""
featuredImagePreview: ""

toc:
  enable: true
math:
  enable: false
lightgallery: false
license: "MIT"
---
## What I want
<!--more-->
v2ray最有意思的是它的可玩性比较好, 你可以自己组装模块, 就像拼积木一样, 下面我们通过一些配置文件的示例来说明它的一些模块的玩法:

_注意: v2ray并不区分客户端和服务端, 你可以把它们通通想象为节点(node)_

下面: 让我们来deploy一个现在比较基础的翻墙网络, 基本的流程图如下:

![](/img/V2ray科学上网方案/v2ray.drawio.png)

解释上图: 

node0 表示用户自己的设备, 比如: 手机(Android, iOS), 电脑(Windows, mac OS, Linux), 其他设备(openWRT), node1表示跳板设备, 关于为什么使用跳板设备, 据我的使用感受, 国内目前连接稳定且性价比较高的cn2-gia提供商只有腾讯轻量香港和阿里云轻量了, 但是直接将它们作为出口节点, 还是会有些不信任, 即使你使用了DOH, ISP 仍然可以获取你访问的IP, 然后反向推出你访问了什么网站, (因为各大云服务上其实都有一个自己的IP库, 这些是可以查找到的), 所有将node1指向node2, node2是一个国外的云服务提供商, 在购买之前, 可以使用node2服务商的测速页面, 在node1上进行测速, 一般香港的vps访问外界速度都是不错的, 然后就形成了一个基本的链式代理, 可能会有朋友面对一个问题, node2有时候google访问会经常出现captcha, 那么可以使用WARP, 一款由cloudflare提供的wireguard服务, 免费的哦, 就是一个基于wireguard的免费vpn, 这样可以规避google的captcha和netflix偶尔出现的ip封锁 😁

