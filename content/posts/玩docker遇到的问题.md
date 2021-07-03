---
title: "Docker旅途中的故事"
date: 2020-07-22T12:44:04+08:00
lastmod: 2020-07-22T12:44:04+08:00
draft: true
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
- 自定义时区的方法

    1. 在Dockerfile 里面添加如下字段: 
    
    ```shell
    ENV TZ=Asia/Shanghai
    ```