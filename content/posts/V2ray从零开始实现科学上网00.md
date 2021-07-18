---
title: "V2ray从零开始实现科学上网00: 配置VPS"
date: 2021-05-18T23:11:01+08:00
lastmod: 2021-05-18T23:11:01+08:00
draft: false
keywords: ["科学上网", "翻墙"]
description: "配置VPS"
tags: ["v2ray", "Linux"]
categories: ["GFW"]
author: "gina"

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: true
toc: true
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: true
---

<!--more-->

>由于国内网络环境的影响, 获取一些国外技术资讯, 需要科学上网技术, 在此记录一下自己在这方面的学习历程吧

目前, 主流的科学上网方式有两种, 一种是加密, 一种是伪装

加密的方式, 稍微接触过一点科学上网的人, 应该都非常熟悉, 例如: vmess on v2ray 就是一种加密方式, 但是缺点是流量没有特征, 容易被 GFW 封禁. 为什么呢? 因为没有特征其实就是最大的特征, 什么人会用完全没有特征的流量呢? 不言自明~

这系列博文, 介绍的科学上网方案, 具有以下特点: 

1. 外表是互联网上非常常见的协议, 内部实现为: tls+websocket+vmess, 外部特征为https长连接
2. 可以在搭建翻墙方案时, 顺便搞一个反向代理, 自己写了其他测试应用, 直接丢到VPS, 通过web server来访问自己的测试应用, 因为web server 一般都套了一层tls, 省得为不同应用搞安全方案了
3. 使用docker部署, 未来可能会改为docker compose, 方便在不同机器上进行部署
4. (可选) 如果你不信任自己的VPS提供商, 担心会被记录访问站点, 可以用第一层VPS做跳板, 跳转到第二层VPS

最好的方式其实是将自己藏匿于人群中, 你可以使用明面上的 https 流量, 域名指向你的网站, 但是, 接收到你的请求的 web 服务器会从你的请求 URL 中判断(URL 是不会被 GFW 查看到的, 例如: 你的网站是: mydomain.com, 请求 URL 是: /say, 那么这个/say 是不会被 GFW 查看到的, 可以知晓的仅仅是: mydomain.com, 为什么呢? 因为 client 在建立 TLS 连接的时候, 仅仅暴露了目标域名, 如果连目标域名都不想暴露的话, 就得使用  [ESNI](https://www.cloudflare.com/learning/ssl/what-is-encrypted-sni/) , 可惜, 国内目前不支持ESNI), 你到底是想要查看自己的网站, 还是想访问特定的 web app, web server 会根据你的 URL 来判断, 有疑惑的话, 随便抓一个https网站的包验证一下😂)

流程图如下:

![](/img/V2ray科学上网方案/proxy.png)

过程如下:

本地设备与 Web 服务器建立 TLS 连接, Web 服务器通过查看设备的 URL, 将请求转发至不同的 App, App具体做什么由你控制, 比如说: 你可以设置: `/free`这个URL作为翻墙应用, `/blog`这个URL作为你的博客应用, `/msg`这个URL作为你的消息通知机器人应用(例如: telegram 中的一些API组合起来做消息机器人), `/` 这个URL作为你的主站点应用.

## 挑选VPS

首先, 你需要挑选一个好用的VPS, 如何判断VPS是否好用呢? 

主要用以下几个工具判断: 

1. tcping
2. traceroute
3. mtr
4. scp

### tcping

> tcping是一款类似ping的工具, 不同的是: ping测试的是ICMP协议, 而tcping测试的是TCP协议

代码地址: [tcping](https://github.com/cloverstd/tcping) , 可以判断延迟 &&  特定端口是否被封

### traceroute

> traceroute可以查看数据包由本地设备发往目的设备的过程中, 经过的网关节点的延时

### mtr

> mtr是一款可以查看数据包在由本地设备发往目的设备的过程中, 查看丢包率等数据

### scp

> scp 是通过ssh协议传输文件的工具, 使用他, 你可以测试从VPS下载文件到本地的速度, 当然, 如果你是公网IP, 也可以测试从本地设备上传文件到VPS的速度, 不过现如今公网IP不多了吧, 所以... 上传测试的话, 还是用[speedtest](https://www.speedtest.net/)吧(注意通过代理访问)

## 部署VPS

然后, 就可以开始部署VPS啦

新的VPS到手, 激动的心情过后, 需要做的事情, 还是不少滴, 参考digitalocean的这篇文章: [Initial server setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04)

### 添加新用户

绝大多数情况下, 不建议直接使用root用户来操作, 而是使用处在sudo用户组中的用户来操作

```bash
# 首先, 切换到root user
# 之后就会开始提醒你, 输入新密码啦
sudo passwd root
# 创建一个新的用户, username设置一个你想要设置的, for instance, `adduser clack`
adduser clark
# 中英文切换好麻烦, 用英文啦
# Add your new user to sudo user group
usermod -aG sudo clark
```

### 使用SSH pubkey连接服务器

```bash
# 生成你的SSH key pair, 密钥在本地设备, 公钥复制到VPS的~/.ssh/authorized_keys 文件中, 博文中有一篇: "ssh登录远程机器且不用密码" 提到这个
# 生成结束后, 本地设备通过SSH连接VPS, 如果成功, 开始
# set /etc/ssh/sshd_config
nano /etc/ssh/sshd_config
# change below:
# Protocol 2    
# Port 22   端口一般情况下不要改
# MaxAuthTries 3  尝试失败次数最大限制为3次
# PermitRootLogin no 不允许root用户登录
# PubkeyAuthentication yes 允许pubkey方式登录
# PasswordAuthentication no 不允许密码登录
sudo systemctl restart sshd.service # 重启sshd服务
```

### 设置UFW rules

```bash
# setting up a basic firewall
# show apps that ufw allowed
sudo ufw app list
# default deny incoming data
sudo ufw default deny incoming
# default allow outgoing data 
sudo ufw default allow outgoing
# add what you want app that can pass the Firewall
sudo ufw allow 22
sudo ufw allow 443
sudo ufw allow $what_you_want_port # 这里一般不用填, 因为我们可能都要走443端口了, 除非你有应用要直接和外网连接
```

## 安装Docker环境

官方的Docker安装教程在此: [Install Docker](https://docs.docker.com/engine/install/ubuntu/), 以Ubuntu环境为例:

```bash
# 卸载旧版本Docker
sudo apt-get remove docker docker-engine docker.io containerd runc
# 添加 Repository
sudo apt update;
sudo apt install apt-transport-https ca-certificates curl gpg lsb-release
# 添加官方gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# 添加官方源
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# 安装Docker
sudo apt-get update;
sudo apt-get install docker-ce docker-ce-cli containerd.io;
# 将当前用户添加进入docker用户组, 让non-root用户可以执行docker命令
sudo usermod -aG docker $USER
# 然后log out and log in 或者执行命令 newgrp docker
# 为了检验non-root用户是否可以直接执行docker命令, 执行下列命令, 成功了会有提示
docker run hello-world
```



## 总结

防火墙规则的添加和sshd_config的修改主要是为了VPS的安全性着想, 你实在是无法想象服务器每天要被探测多少次🤣(看一眼sshd.service的status和log会让你有所感触), 这只是最基本的防护手段, 还有一些监测系列, 以后再发吧.

