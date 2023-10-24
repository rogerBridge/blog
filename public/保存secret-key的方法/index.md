# 保存secret key的想法


<!--more-->

有个想法, 有没有可能知道一个区块链的公钥地址, 拿到它的私钥呢? 

如果我把私钥加密, 用转账的形式, 给自己转账的时候添加一个备注信息, 备注信息就是加密后的私钥, 使用对称加密方法, 只需要我记的自己的密码就好,

那完整的流程就是:

```mermaid
graph LR
   origin -- sha256 --> bytesArray -- AES256GCM+message --> encryptedBytes -- base64 --> storeString
```

步骤如下:

1. 首先, 设置一个自己的origin, origin就是你的密码;
2. 然后, 使用SHA256SUM方法, 生成自己密码的摘要, []byte, 32个字节的长度;
3. 然后, 使用AES256GCM的方法, 输入密码摘要和需要加密的字符串(也就是你的密钥或者助记词), 生成字节流, 为了便于肉眼查看和避免传输过程中包含特殊字符出现意外情况, 使用base64编码;

具体的执行代码在此: [link](https://gist.github.com/rogerBridge/4595e52040556ac6ecd000fb18d2db0a)

其实还可以使用gpg, 一个很好玩的工具, 先挖个坑, 以后填~

