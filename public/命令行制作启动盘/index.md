# Linux环境下制作启动盘

<!--more-->
在Linux环境下, 如何烧录ISO启动盘到一个USB设备上呢?

```bash
# assume you are in sudo user group
# assume your usb device is /dev/sdx
umount /dev/sdx;
# assume you want your USB file system is fat
sudo mkfs.vfat /dev/sdx -I
# start dd ISO to USB
dd if='ISO file location' of=/dev/sdx bs=4M && sync;
# wait it finish, bingo :)
```
