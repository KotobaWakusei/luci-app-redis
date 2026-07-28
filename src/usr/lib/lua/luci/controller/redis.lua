module("luci.controller.redis", package.seeall)

function index()
	if not nixio.fs.access("/etc/init.d/redis") then
		return
	end

	entry({"admin", "services", "redis"}, firstchild(), _("Redis"), 45).dependent = true

	entry({"admin", "services", "redis", "overview"}, call("redis_overview"), _("Overview"), 1).leaf = true
	entry({"admin", "services", "redis", "status"}, call("redis_status")).leaf = true
	entry({"admin", "services", "redis", "command"}, call("redis_command")).leaf = true
	entry({"admin", "services", "redis", "keys"}, call("redis_keys")).leaf = true
	entry({"admin", "services", "redis", "setkey"}, post("redis_setkey")).leaf = true
	entry({"admin", "services", "redis", "delkey"}, post("redis_delkey")).leaf = true
	entry({"admin", "services", "redis", "action"}, post("redis_action")).leaf = true
end

function redis_overview()
	local http = require "luci.http"
	local tpl = require "luci.template"
	tpl.render("redis/overview")
end

function redis_status()
	local sys = require "luci.sys"
	local http = require "luci.http"
	http.prepare_content("application/json")

	local running = (sys.call("pgrep -af redis-server >/dev/null 2>&1") == 0)
	local pid = sys.exec("pgrep -af redis-server 2>/dev/null | grep -v grep | head -1 | awk '{print $1}'"):gsub("%s+", "")
	local mem = sys.exec("ps -o rss= -p " .. pid .. " 2>/dev/null | head -1"):gsub("%s+", "")
	mem = mem or "0"
	mem = tonumber(mem) or 0

	local uptime_s = sys.exec("cat /proc/" .. pid .. "/stat 2>/dev/null | awk '{print $16}'"):gsub("%s+", "")

	local info = sys.exec("redis-cli -n 0 info server 2>/dev/null | head -20")
	local info_clients = sys.exec("redis-cli -n 0 info clients 2>/dev/null | head -10")
	local info_keyspace = sys.exec("redis-cli -n 0 info keyspace 2>/dev/null | grep -v '^#'")

	local redis_version = "unknown"
	local redis_mode = "standalone"
	local redis_tcp_port = "6379"
	for line in info:gmatch("[^\r\n]+") do
		local k, v = line:match("^([^:]+):(.+)")
		if k == "redis_version" then redis_version = v end
		if k == "redis_mode" then redis_mode = v end
		if k == "tcp_port" then redis_tcp_port = v end
	end

	local clients = 0
	for line in info_clients:gmatch("[^\r\n]+") do
		local k, v = line:match("^connected_clients:(.+)")
		if k then clients = tonumber(v) or 0 end
	end

	local keyspace = {}
	for line in info_keyspace:gmatch("[^\r\n]+") do
		local db, keys_count = line:match("^db(%d+):keys=(%d+)")
		if db and keys_count then
			keyspace[db] = tonumber(keys_count) or 0
		end
	end

	http.write_json({
		running = running,
		pid = tonumber(pid) or 0,
		memory_kb = mem,
		uptime_seconds = tonumber(uptime_s) or 0,
		version = redis_version,
		mode = redis_mode,
		port = redis_tcp_port,
		clients = clients,
		keyspace = keyspace
	})
end

function redis_command()
	local http = require "luci.http"
	local sys = require "luci.sys"

	local cmd = http.formvalue("cmd") or "ping"
	local db = http.formvalue("db") or "0"

	http.prepare_content("application/json")

	local result = sys.exec("redis-cli -n " .. db .. " " .. cmd .. " 2>&1")
	http.write_json({result = result:gsub("%s+$", "")})
end

function redis_keys()
	local http = require "luci.http"
	local sys = require "luci.sys"
	local db = http.formvalue("db") or "0"

	http.prepare_content("application/json")

	local keys = {}
	local raw = sys.exec("redis-cli -n " .. db .. " keys '*' 2>&1")
	for line in raw:gmatch("[^\r\n]+") do
		if line ~= "" and not line:match("^#") and not line:match("^ERR") then
			keys[#keys + 1] = line
		end
	end

	http.write_json({keys = keys, count = #keys})
end

function redis_setkey()
	local http = require "luci.http"
	local sys = require "luci.sys"
	local db = http.formvalue("db") or "0"
	local key = http.formvalue("key") or ""
	local value = http.formvalue("value") or ""

	http.prepare_content("application/json")

	if key == "" then
		http.write_json({error = "Key is required"})
		return
	end

	local result = sys.exec("redis-cli -n " .. db .. " SET " .. sys.uq(key) .. " " .. sys.uq(value) .. " 2>&1")
	http.write_json({result = result:gsub("%s+$", "")})
end

function redis_delkey()
	local http = require "luci.http"
	local sys = require "luci.sys"
	local db = http.formvalue("db") or "0"
	local key = http.formvalue("key") or ""

	http.prepare_content("application/json")

	if key == "" then
		http.write_json({error = "Key is required"})
		return
	end

	local result = sys.exec("redis-cli -n " .. db .. " DEL " .. sys.uq(key) .. " 2>&1")
	http.write_json({result = result:gsub("%s+$", "")})
end

function redis_action()
	local http = require "luci.http"
	local sys = require "luci.sys"
	local action = http.formvalue("action") or "start"

	http.prepare_content("application/json")

	local cmd = "/etc/init.d/redis " .. action
	local result = sys.exec(cmd .. " 2>&1")
	http.write_json({result = result:gsub("%s+$", "")})
end