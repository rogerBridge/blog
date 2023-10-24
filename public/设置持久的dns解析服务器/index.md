# Linux下设置持久的DNS解析服务器

<!--more-->

- 系统: Ubuntu 20.04 LTS

  方法一: resolvconf, 这个包可以在每次启动的时候, 修改/etc/resolv.conf文件, 持久化用户的nameserver设置

```bash
sudo apt update
sudo apt install resolvconf
sudo nano /etc/resolvconf/resolv.conf.d/head # add nameserver 119.29.29.29
sudo systemctl restart resolvconf.service # Then logout and login
```
