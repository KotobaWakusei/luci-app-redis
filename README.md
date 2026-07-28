# luci-app-redis

A LuCI web interface for managing Redis server on OpenWrt and similar embedded Linux systems.

## Features

- Real-time Redis server status (running/stopped, auto-refreshing every 5 seconds)
- Start / Stop / Restart Redis service from the web UI
- Server information display (version, mode, port, PID, memory, uptime, connected clients)
- Quick command execution (PING, INFO, DBSIZE, etc.)
- Key browser (list keys, view values, delete keys)

## Installation

### OpenWrt (ipk)

```
opkg update
opkg install luci-app-redis
```

### Alpine Linux (apk)

```
apk add luci-app-redis
```

## Build from source

### OpenWrt (ipk)

```
make package/luci-app-redis/compile V=s
```

### Alpine Linux (apk)

```
abuild -r
```

## Usage

After installation, access the Redis management page at:

`https://<router-ip>/cgi-bin/luci/admin/services/redis`

Menu path: **Services** > **Redis**

## Requirements

- Redis server installed on the target system
- LuCI web interface (OpenWrt) or similar web framework
- Python 3 (for APK build on Alpine)

## License

MIT