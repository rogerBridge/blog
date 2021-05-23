---
title: "V2ray科学上网方案(v2ray+tls+webServer+docker+中转)"
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
comment: true
toc: true
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: true
---

<!--more-->

目前, 主流的科学上网方式有两种, 一种是加密, 一种是伪装

加密的方式, 稍微接触过一点科学上网的人, 应该都非常熟悉, 例如: vmess on v2ray 就是一种加密方式, 但是缺点是流量没有特征, 容易被 GFW 封禁. 为什么呢? 因为没有特征其实就是最大的特征, 什么人会用完全没有特征的流量呢? 嘿嘿~

这份科学上网方案是我在漫长的使用过程中总结出来的, 具有的特点:

1. 外表是互联网上非常常见的协议, https+websocket
2. 使用docker部署, 未来将改为docker compose, 更加便捷
3. (可选) 如果你不信任自己的VPS提供商, 担心会被记录访问站点, 可以用第一层VPS做跳板, 跳转到第二层VPS

最好的方式其实是将自己藏匿于人群中, 你可以使用明面上的 https 流量, 域名指向你的网站, 但是, 接收到你的请求的 web 服务器会从你的请求 URI 中判断(URI 是不会被 GFW 查看到的, 例如: 你的网站是: mydomain.com, 请求 URI 是: /say, 那么这个/say 是不会被 GFW 查看到的, 可以知晓的仅仅是: mydomain.com, 为什么呢? 因为 SNI 在建立 TLS 连接的时候, 仅仅暴露了目标域名, 如果连目标域名都不想暴露的话, 就得使用 ESNI), 你到底是想要查看自己的网站, 还是想访问特定的 web app, Web Server 会根据你的 URI 来判断, 流程图如下:

![](/img/V2ray科学上网方案/proxy.png)

过程如下:

本地设备与 Web 服务器建立 TLS 连接, Web 服务器通过查看设备的 URI, 将请求转发至不同的 App, 下面是服务器的配置(为了简单, 这里我们使用[Caddy](https://github.com/caddyserver/caddy) 服务器, 并且假设我们将 v2ray App 配置在 localhost:10000)

## Caddy 的配置过程

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

使用 docker 方式启动 Caddy

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
    # $(yourSitePath) 和 $(CaddyfilePath) 是本地设备存放网站文件和Caddyfile文件的路径, 比如说: 你本地网站文件的存放路径是: ~/localSite, 你的Caddyfile文件的存放路径是: ~/localSite/config/Caddyfile, 那么$(yourSitePath)=~/localSite, $(CaddyfilePath)=~/localSite/config/Caddyfile, 注意, $(yourSitePath)里面最好放一些网站文件, 例如可以将自己的博客文件放置在里面, 使用静态站点生成器hugo或者hexo可以很容易生成一个站点文件, 既可以科学上网, 又可以放置博客, 一举两得😀

```

## V2ray 的配置过程

### Server Side

v2ray App 的配置放在 docker 中, 配置文件如下:
**config.json**

```bash
{
    "inbounds": [
        {
          "port": 10000, # 这个就是你的Web Server访问你的V2ray应用所用的端口
          "protocol": "vmess",
          "settings": {
            "clients": [
              {
                "id": "", # 可以用 `uuidgen -r`随机生成一个, for example: 40986f00-deeb-4bdf-86e9-c4fcceb70b03
                "alterId": 64
              }
            ]
          },
          "streamSettings": {
            "network": "ws",
            "wsSettings": {
            "path": "/youWant" # 自己改一下, 随便设置, V2ray app只会处理这个path的请求
            }
          }
        }
      ],
    "outbounds": [
        {
      "protocol": "freedom",
      "settings": {}
      }
    ]
  }
```
使用docker的方式启动V2ray
**runV2rayApp.sh**

```bash
#!/bin/bash
# 这里, $(configDir)指的是存放v2ray配置文件的目录, 例如:你的v2ray配置文件存放在: ~/config/config.json, 那么就把$(configDir)替换为: ~/config,这样, 映射到docker里面就是: /etc/v2ray/config.json, 至于端口映射为什么用127.0.0.1:10000, 是为了确保访问只能从web server进行
docker run -d \
  --name v2rayServer \
  -v $(configDir):/etc/v2ray \
  --restart=always \
  -p 127.0.0.1:10000:10000 \
  v2fly/v2fly-core v2ray -config=/etc/v2ray/configNode1.json
```



以上就是服务器端的配置流程

### Client Side

客户端的配置, 这里重点讲一下linux系统的配置, Win和安卓直接粘贴配置文件导入即可, 这里就不赘述了

**configV2rayClient.json**

```bash
{
  "dns": {
    "hosts": {
      "domain:googleapis.cn": "googleapis.com"
    },
    "servers": ["1.1.1.1"]
  },
  "inbounds": [
    {
      "listen": "0.0.0.0", // 这里必须写0.0.0.0, 原因是: 如果写127.0.0.1的话, docker无法和我们本机沟通
      "port": 10000, // This is local V2ray port, socks5
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": ["http", "tls"],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "listen": "0.0.0.0",
      "port": 10010, // This is local V2ray port, http
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "info"
  },
  "outbounds": [
    {
      "mux": {
        "concurrency": -1,
        "enabled": false
      },
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "your.domain", # 这里填写你的站点, 不用加协议信息, 直接填写域名就好
            "port": 443,
            "users": [
              {
                "alterId": 64,
                "id": "", # 这里填写你的服务端uuid
                "level": 8,
                "security": "auto"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": false,
          "serverName": ""
        },
        "wsSettings": {
          "headers": {
            "Host": ""
          },
          "path": "/youWant" # 这里填写你的path
         }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "policy": {
    "levels": {
      "8": {
        "connIdle": 300,
        "downlinkOnly": 1,
        "handshake": 4,
        "uplinkOnly": 1
      }
    },
    "system": {
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    # 路由这块可以自己定义, 这里我将域名 googleapis.cn添加进了proxy规则
    "rules": [
      {
        "domain": ["domain:googleapis.cn"],
        "outboundTag": "proxy",
        "type": "field"
      },
      {
        "ip": ["geoip:private"],
        "outboundTag": "direct",
        "type": "field"
      },
      {
        "ip": ["geoip:cn"],
        "outboundTag": "direct",
        "type": "field"
      },
      {
        "domain": ["geosite:cn"],
        "outboundTag": "direct",
        "type": "field"
      }
    ]
  },
  "stats": {}
}

```

**runV2rayClient.sh**

```bash
#!/bin/bash
# 这里指定127.0.0.1, 是为了只让本机访问docker, 如果你需要让其他设备通过你的本机科学上网, 将它们改为0.0.0.0
docker run -d --name v2ray \
  --name v2rayRabbit \
  -p 127.0.0.1:10000:10000 \
  -p 127.0.0.1:10010:10010 \
  -v $(configV2rayClientDir):/etc/v2ray \
  -w /etc/v2ray \
  --restart=always \
  v2fly/v2fly-core:latest  v2ray -config=configV2rayClient.json

```

这里就初步完成了, 可以测试一下