# issue945

This repo for [issue945](https://github.com/cloudwu/skynet/issues/945)

### 目录结构

```bash
.
├── LICENSE
├── README.md
├── config
│   ├── cluster_list.lua
│   ├── config.c1
│   ├── config.c2
│   └── config_public
├── server
│   └── skynet
│       ├── 3rd
│       ├── HISTORY.md
│       ├── LICENSE
│       ├── Makefile
│       ├── README.md
│       ├── cservice
│       ├── examples
│       ├── luaclib
│       ├── lualib
│       ├── lualib-src
│       ├── platform.mk
│       ├── service
│       ├── service-src
│       ├── skynet
│       ├── skynet-src
│       ├── skynet.dSYM
│       └── test
└── src
    ├── c1.lua
    ├── c2.lua
    ├── common
    │   └── tool.lua
    ├── harbor.lua
    ├── monitor.lua
    └── preload
        └── preload.lua

```

## 复现

```bash
cd  .git 同级目录下

./server/skynet/skynet ./config/config.c1
```

此时一切正常，但打开一个新的 shell 后输入

```bash
./server/skynet/skynet ./config/config.c2
```

日志卡在了

```bash
[:0000000a] LAUNCH snlua harbor
```

用 debug console 连接上 c1，输入 service

```bash
➜  ~ telnet 127.0.0.1 8000
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Welcome to skynet console
service
@monitor	:0000000b
clusterd	:00000009
snaxd.pingserver	:00000013
<CMD OK>
Connection closed by foreign host.
```

用 debug console 连接上 c2，输入 service

```bash
➜  ~ telnet 127.0.0.1 8001
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Welcome to skynet console
service
@monitor	Querying:
:0000000b stack traceback:
	[C]: in function 'skynet.profile.yield'
	./server/skynet/lualib/skynet.lua:353: in upvalue 'yield_call'
	./server/skynet/lualib/skynet.lua:373: in function 'skynet.call'
	./server/skynet/lualib/skynet.lua:632: in function 'skynet.queryservice'
	././src/harbor.lua:10: in function <././src/harbor.lua:9>
	[C]: in function 'xpcall'
	././src/harbor.lua:30: in upvalue 'f'
	./server/skynet/lualib/skynet.lua:138: in function <./server/skynet/lualib/skynet.lua:110>
clusterd	:00000009
<CMD OK>
```
