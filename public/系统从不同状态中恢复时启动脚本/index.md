# 系统从休眠状态中恢复时启动脚本

<!--more-->

遇到一个问题, 系统从hibernate状态中恢复后, systemd中的一个自定义服务, 不运行了, 解决办法是: 加入新的Target

```ASCII
[Unit]
Description=Run my scripts
# After=suspend.target # 在suspend之后执行
After=hibernate.target
# After=hybrid-sleep.target

[Service]
ExecStart=/some/path/run/yourScript

[Install]
WantedBy=default.target # 启动时引导至unit
# WantedBy=suspend.target # suspend时引导至unit
WantedBy=hibernate.target
# WantedBy=hybrid-sleep.target
```

