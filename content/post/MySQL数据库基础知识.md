---
title: "MySQL数据库基础知识"
date: 2021-01-01T10:12:40+08:00
lastmod: 2021-01-01T10:12:40+08:00
draft: false
keywords: ["数据库"]
description: ""
tags: []
categories: ["数据库"]
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
1. MySQL 如何优化查询?

   - 索引一般有哪几种结构?

   - 索引是一种数据结构, 一般有hash, B树, B+树

   - 索引为什么使用这种结构?B+树, data存储在叶子节点, key存储在分支节点, 可以降低树的高度, 提高查询的效率

2. myasim vs innode

   - 

3. 删除表里面的数据的时候, 使用delete和truncate的区别是什么?

- truncate会使主键自增归零, delete则不会

4. inner join 常用的联表查询?

   ```mysql
   --inner join
   select u.userID, username, height, weight
   from user u
   left join result r
   on u.userID = r.userID
   ```

5. 聚合函数

   select(*) compare select column_name, select column_name not include null value;

   group by [group condition]

   having [condition]

6. md5(str+salt)

7. 事务

   ACID

8. 索引

   索引是数据结构

   - 主键索引
   - 唯一索引
   - 常规索引(经常变化的数据不要加索引;)
   - 全文索引

9. 索引的数据结构

   B+ tree

10. 备份数据库

    数据库备份, 非常非常非常重要!!!

11. 数据库设计

    - 分析业务, 需要处理的数据
    - 设计表结构(任何情况下, 都不要使用外键)

12. 三大范式

13. SQL 注入

    - `column or 1=1`

      

