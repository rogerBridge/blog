---
title: "V2ray从零开始实现科学上网01: 编写配置文件(writing)"
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
## 大概目标
<!--more-->
v2ray最有意思的是它的可玩性比较好, 你可以自己组装模块, 就像拼积木一样, 下面我们通过一些配置文件的示例来说明它的一些模块的玩法:

_注意: v2ray并不区分客户端和服务端, 你可以把它们通通想象为节点(node)_

下面: 让我们来deploy一个现在比较基础的翻墙网络, 基本的流程图如下:

![](/img/V2ray科学上网方案/v2ray.drawio.png)

解释上图: 

node0 表示用户自己的设备, 比如: 手机(Android, iOS), 电脑(Windows, mac OS, Linux), 其他设备(openWRT), node1表示跳板设备, 关于为什么使用跳板设备, 据我的使用感受, 国内目前连接稳定且性价比较高的cn2-gia提供商只有腾讯轻量香港和阿里云轻量了, 但是直接将它们作为出口节点, 还是会有些不信任, 即使你使用了DOH, ISP 仍然可以获取你访问的IP, 然后反向推出你访问了什么网站, (因为各大云服务上其实都有一个自己的IP库, 这些是可以查找到的), 所有将node1指向node2, node2是一个国外的云服务提供商, 在购买之前, 可以使用node2服务商的测速页面, 在node1上进行测速, 一般香港的vps访问外界速度都是不错的, 然后就形成了一个基本的链式代理, 可能会有朋友面对一个问题, node2有时候google访问会经常出现captcha, 那么可以使用WARP, 一款由cloudflare提供的wireguard服务, 免费的哦, 就是一个基于wireguard的免费vpn, 这样可以规避google的captcha和netflix偶尔出现的ip封锁 😁

## 搭建一个网站

为了实现tls+websocket, 我们需要搭建一个网站, 比较通用的方法是: 使用nginx来处理tls, 并且将用户访问的url指向相应的代理服务器, 当然, 你也可以直接用go写一个http.ListenAndServeTLS(), 都是可以的, 但是毕竟前者更加通用嘛 : )

一般的网络应用是这样搞的: nginx负责处理tls, load balance, reverse proxy, compress file, rate limit etc, 然后nginx后方代理一堆app;

为了伪装的像正常的上网流量, 并且是大流量, 一般建议代理一个网盘应用, 这里推荐[cloudreve](https://cloudreve.org), 

下面我们先搞一个cloudreve网站吧, 嘿嘿

### 搭建nginx-certbot

在你的node1中搭建, 有一个应用将nginx和certbot结合在了一起, 强烈推荐使用: [nginx-certbot](https://github.com/wmnnd/nginx-certbot) 

这里是我稍微修改了一下下的docker-compose.yml, 主要是将nginx的版本更新到1.21.1, 将network_mode更新为: host

```yml 
version: '3'

services:
  nginx:
    image: nginx:1.21.1
    restart: unless-stopped
    volumes:
      - ./data/nginx:/etc/nginx/conf.d
      - ./data/certbot/conf:/etc/letsencrypt
      - ./data/certbot/www:/var/www/certbot
    network_mode: "host"
    command: "/bin/sh -c 'while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g \"daemon off;\"'"
  certbot:
    image: certbot/certbot
    restart: unless-stopped
    volumes:
      - ./data/certbot/conf:/etc/letsencrypt
      - ./data/certbot/www:/var/www/certbot
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"

```

注意follow github的readme.md里面的指引, 为你的域名申请证书

然后执行: ```docker-compose up -d```

这时候你的node1中就会出现两个container, 用```docker ps```即可查看

然后, 使用docker搭建[cloudreve](https://github.com/cloudreve/Cloudreve)

```bash
docker run -d \
  --name cloudreve \
  -e PUID=1000 \ # optional
  -e PGID=1000 \ # optional
  -e TZ="Asia/Shanghai" \ # optional
  -p 127.0.0.1:5212:5212 \
  --restart=unless-stopped \
  -v <PATH TO uploads>:/cloudreve/uploads \
  -v <PATH TO config>:/cloudreve/config \
  -v <PATH TO db>:/cloudreve/db \
  -v <PATH TO avatar>:/cloudreve/avatar \
  xavierniu/cloudreve
# first time use, you need get password from docker logs -f cloudreve  
```

之后, 在nginx-certbot文件夹中修改data/nginx/app.conf

```bash
server {
    listen 443 ssl;
    server_name {yourdomain}; # 这里, 假如你的域名是: hello.com, 那你就填入: hello.com, 不要傻乎乎的填: {yourdomain}, 这就是一个参数而已
    server_tokens off;

    ssl_certificate /etc/letsencrypt/live/{yourdomain}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/{yourdomain}/privkey.pem;

    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        client_max_body_size 128M;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://127.0.0.1:5212; # 这里就是你的cloudreve的本地地址

    # 如果您要使用本地存储策略，请将下一行注释符删除，并更改大小为理论最大文件尺寸
    # client_max_body_size 20000m;
        # root /etc/nginx/conf.d/html;
        # index index.html;
        # proxy_set_header    Host                $http_host;
        # proxy_set_header    X-Real-IP           $remote_addr;
        # proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
    }
    
}
```

然后, 试试访问: https://{yourdomain}/, 如果可以正常访问, 恭喜你, 第一步已经完成啦~

## 编写node0, node1, node2 的配置文件

node0是距离用户最近的节点, 一般来说, node0需要向用户提供一个本地的socks5和http代理服务器, 向外寻找node1的时候, 需要走tls+websocket协议, 实例配置文件如下:

### node0 

#### log.json

```json
{
  "log": {
    "loglevel": "warning"
  }
}
```

#### dns.json

```json
{
  "dns": {
    "hosts": {
      "geosite:category-ads-all": "127.0.0.1",
      "{yourdomain}": "{the IP address of your VPS}"
    },
    "servers": [
      {
        "address": "https://1.0.0.1/dns-query", # send DoH request to VPS, if "https+local://1.0.0.1/dns-query", then send DoH request directly from localhost
        "skipFallback": true
      },
      {
        "address": "223.5.5.5",
        "domains": [
          "geosite:cn"
        ]
      },
      {
        "address": "119.29.29.29",
        "domains": [
          "geosite:cn"
        ]
      },
      "119.29.29.29",
      "localhost"
    ]
  }
}
```

#### routing.json

```json
{
  "routing": {
    "domainMatcher": "mph",
    "domainStrategy": "IPIfNonMatch", # 其实我个人更加倾向AsIS
    "rules": [
      // United States Proxy
      {
        "type": "field",
        "inboundTag": ["socksUS", "httpUS"],
        "outboundTag": "direct",
        "ip": ["223.5.5.5", "119.29.29.29", "223.6.6.6", "geoip:private", "geoip:cn"]
      },
      {
        "type": "field",
        "inboundTag": ["socksUS", "httpUS"],
        "outboundTag": "direct",
        "domain": [
          "ext:mine.dat:direct",
          "geosite:cn",
          "geosite:category-games@cn"
        ]
      },
      {
        "type": "field",
        "inboundTag": ["socksUS", "httpUS"],
        "outboundTag": "block",
        "domain": ["geosite:category-ads-all", "ext:mine.dat:block"]
      },
      {
        "type": "field",
        "inboundTag": ["socksUS", "httpUS"],
        "outboundTag": "outboundUS",
        "network": "tcp,udp"
      }
    ]
  }
}

```

#### inbounds.json

```json
{
  "inbounds": [
    // United States
    {
      "settings": {
        "udp": true,
        "auth": "noauth",
        "userLevel": 0
      },
      "listen": "0.0.0.0", # 这里为什么使用0.0.0.0, 因为配置文件要被container使用, 如果用127.0.0.1的话, 本地映射不出来
      "protocol": "socks",
      "port": 10830,
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      },
      "tag": "socksUS"
    },
    {
      "settings": {
        "userLevel": 0
      },
      "listen": "0.0.0.0",
      "protocol": "http",
      "port": 10831,
      "tag": "httpUS"
    }
  ]
}
```

#### outbound.json

```json
{
  "outbounds": [
    {
      "settings": {
        "vnext": [
          {
            "address": "{yourdomain}",
            "users": [
              {
                "id": "abcb3604-620a-4d84-ba0f-9274cf8c703a", # 使用uuidgen生成一个就好
                "level": 0,
                "alterId": 0,
                "security": "auto",
                "email": "{username}@v2fly.org"
              }
            ],
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "wsSettings": {
          "headers": {
            "Host": ""
          },
          "path": "/0ON36ts1"
        },
        "tlsSettings": {
          "serverName": "",
          "allowInsecure": false
        },
        "network": "ws",
        "security": "tls"
      },
      "protocol": "vmess",
      "tag": "outboundUS"
    }
  ]
}
```

#### policy.json

```json
{
  "policy": {
    "system": {
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    },
    "levels": {
      "8": {
        "handshake": 4,
        "connIdle": 300,
        "downlinkOnly": 1,
        "uplinkOnly": 1
      }
    }
  }
}
```

#### base.json

```json
{
    "log": {},
    "dns": {},
    "stats": {},
    "policy": {},
    "transport": {},
    "routing": {},
    "inbounds": [],
    "outbounds": []
}
```

然后, 将这些文件全部打包放入confDir文件夹, 至此, node0 的v2ray文件夹目录如下:

```bash
node0
--asset(dir) # 用来放置路由文件, 推荐一个repository [v2ray-rules-dat](https://github.com/Loyalsoldier/v2ray-rules-dat)
--confDir(dir) # 用来放置*.json文件
--env # environment variables file
--run.sh # run v2ray node0 file
```

#### env

```text
V2RAY_BUF_READV=enable
V2RAY_CONF_GEOLOADER=memconservative
```

#### run.sh

```bash
#!/bin/bash
# docker restart v2ray;
# docker network create gfw --subnet=172.18.0.0/24 --gateway=172.18.0.1

docker run -d \
  --name v2ray \
  -v $PWD/confdir:/etc/v2ray/confdir \
  -v $PWD/asset:/usr/local/share/v2ray/ \
  --env-file=$PWD/env \
  --restart=unless-stopped \
  --network=gfw \
  --network-alias=v2ray \
  --ip=172.18.0.2 \
  v2fly/v2fly-core:v4.40.1 v2ray -confdir=/etc/v2ray/confdir
```

