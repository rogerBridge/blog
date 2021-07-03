---
title: "MySQL数据库基础知识"
date: 2021-01-01T10:12:40+08:00
lastmod: 2021-01-01T10:12:40+08:00
draft: true
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

   **事务就是一组原子性的SQL操作或者一个独立的工作单元，事务内的语句要么全部执行成功，要么全部执行失败。**

   *比如说用户申请注销账户, 和用户关联的表一般情况下不止一张, 全部将`is_delete`状态赋值为true的话, 过程中不可以中断, 这个操作我们就需要数据库事务的介入啦~*

   事务包含的四大特性:

   1. 原子性
       比如: UPDATE Customers SET language = 'English' WHERE Region = 'American' 
       American包含几个不同的地区, 不可能存在这个语句修改了一部分, 而另外一部分没有被修改的情况; 要不全部修改, 要不失败而什么都没有修改;
   2. 一致性
       应用从一个正确的状态迁移到另外一个正确的状态;
   3. 隔离性
       多个用户并发的修改同一张表的数据时, 数据库对每个用户开启单独的事务, 不能被其他事务所干扰, 多个并发事务之间需要相互隔离.
   4. 持久性
       一个事务一旦被提交了, 那么就是可以持久保存在磁盘的, Mysql中会有相应的操作日志, 即使需要恢复数据, 也可以根据日志恢复最后一次更新;

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

      

