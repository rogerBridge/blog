---
title: "Redis基础知识[ing]"
date: 2021-01-01T10:14:57+08:00
lastmod: 2021-01-01T10:14:57+08:00
draft: false
keywords: []
description: ""
tags: []
categories: ["Redis"]
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
- redis 有几个database?
  0~15, all is 16

- redis 如何配置主从复制呢?
  slaveof

- 什么是缓存穿透? 如何解决?
  缓存穿透就是请求在缓存中没有找到想到的key, 然后只好去DB里面去查询;
  解决办法是: 1. 缓存key: nil到缓存中, 但是要设置过期时间哦 2. 布隆过滤器, 在缓存之前加一层布隆过滤器, 布隆过滤器中找不到的数据, 就不找了, 直接返回空值;

- 什么是缓存击穿? 如何解决?
  高并发访问一个数据, 这时, 缓存中的数据失效了, 这时, 高并发的请求就会直接打到DB中;
  解决办法是: 一个请求先进去mqsql里面拿到数据, 如果不存在于缓存中, 就给redis里面添加热点数据, 这样, 其他请求就会在redis里面找到这条数据;

- 什么是缓存雪崩? 如何解决?
  当某一时刻发生大规模的缓存失效的情况, 比如: 缓存挂了;
  解决办法是: 事前: 主从redis + 哨兵
  事中: 本地限流, 防止Mysql被打死
  事后: 开启redis持久化机制

- Redis持久化如何做到?
  - 每隔一段设定的时间, 将内存数据取出到硬盘上(RDB)
  - AOF, 将命令保存在硬件中

- Redis集群的相关问题

- zset的应用, 消息带权重进行判断

- watch 命令可以当作乐观锁来操作

- 