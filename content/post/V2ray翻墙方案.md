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

最好的方式其实是将自己藏匿于人群中, 你可以使用明面上的https流量, 域名指向你的网站, 但是, 接收到你的请求的web服务器会从你的请求URI中判断(URI是不会被GFW查看到的, 例如: 你的网站是: mydomain.com, 请求URI是: /say, 那么这个/say是不会被GFW查看到的, 可以知晓的仅仅是: mydomain.com, 为什么呢? 因为SNI在建立TLS连接的时候, 仅仅暴露了目标域名, 如果连目标域名都不想暴露的话, 就得使用ESNI), 你到底是想要查看自己的网站, 还是想访问特定的web app, Web Server会根据你的URI来判断, 流程图如下:

![](/img/V2ray翻墙方案/proxy.png)

过程如下:

本地设备与Web服务器建立TLS连接, Web服务器通过查看设备的URI, 将请求转发至不同的App, 下面是服务器的配置(为了简单, 这里我们使用[Caddy](https://github.com/caddyserver/caddy) 服务器, 并且假设我们将v2ray App 配置在localhost:10000)



## Caddy的配置过程

**Caddyfile**

```
your.domain {
    root *  /usr/share/caddy
    encode zstd gzip
    file_server

    log {
	    output file /etc/caddy/caddy.log
	}

    tls {
	    protocols tls1.3
	    ciphers TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
	    curves x25519
	}
    
    # 这里就是我们的v2ray App, URI 设定为/youWant
    @v2ray_websocket {
		path /youWant
		header Connection *Upgrade*
		header Upgrade websocket
	}
    
    reverse_proxy @v2ray_websocket 127.0.0.1:10000
}

```



使用docker方式启动Caddy

**runCaddy.sh**

```bash
#!/bin/bash
# docker stop caddy && docker rm caddy; # 注意, 这一步如果你有名为caddy的docker应用, 绝对不可以做

docker run -d \
    --network=host \
    --name=caddy \
    -v $(yourSitePath):/usr/share/caddy \
    -v $(CaddyfilePath):/etc/caddy/Caddyfile \
    caddy
    # $(yourSitePath) 和 $(CaddyfilePath) 是本地设备存放网站文件和Caddyfile文件的路径, 比如说: 你本地网站文件的存放路径是: ~/localSite, 你的Caddyfile文件的存放路径是: ~/localSite/config/Caddyfile, 那么$yourSitePath=~/localSite, $CaddyfilePath=~/localSite/config/Caddyfile

```

v2ray App的配置放在docker中
