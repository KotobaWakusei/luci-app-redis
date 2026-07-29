# luci-app-redis

A LuCI web interface for managing Redis server on OpenWrt and similar embedded Linux systems.

## Features

- Real-time Redis server status monitoring with auto-refresh
- Start / Stop / Restart Redis service from the web UI
- Server information display (version, mode, port, PID, memory, uptime, clients)
- Quick command execution (PING, INFO, DBSIZE, GET, SET, etc.)
- Key browser (list keys, view values, delete keys)

## Known Compatible LuCI Versions

- LuCI 23.x (Lua version)
- LuCI 25.x (ucode version, Kwrt)
- Other LuCI versions with standard controller/view support

## Installation

### OpenWrt

```
opkg update
opkg install luci-app-redis
```

### Build from source

```bash
make package/luci-app-redis/compile V=s
```

## Usage

After installation, access the Redis management page at:

```
http://<router-ip>/cgi-bin/luci/admin/services/redis/overview
```

Menu path: **Services** > **Redis**

## File Structure

```
src/usr/lib/lua/luci/controller/redis.lua
src/usr/lib/lua/luci/view/redis/overview.htm
src/usr/share/rpcd/acl.d/luci-app-redis.json
```

## Requirements

- Redis server installed (`redis-server` package on OpenWrt)
- LuCI web interface (OpenWrt: `luci-base`)

## License

MIT