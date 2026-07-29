module("luci.controller.redis", package.seeall)

function index()
	entry({"admin", "services", "redis"}, firstchild(), _("Redis"), 45).dependent = false

	entry({"admin", "services", "redis", "overview"}, call("redis_overview"), _("Overview"), 1).leaf = true
	entry({"admin", "services", "redis", "status"}, call("redis_status")).leaf = true
	entry({"admin", "services", "redis", "command"}, call("redis_command")).leaf = true
	entry({"admin", "services", "redis", "action"}, call("redis_action")).leaf = true
end

function redis_overview()
	luci.template.render("redis/overview")
end

function redis_status()
	local http = require "luci.http"
	local sys = require "luci.sys"
	http.prepare_content("application/json")
	local rc = sys.call("redis-cli -n 0 ping >/dev/null 2>&1")
	if rc ~= 0 then
		http.write_json({running = false})
		return
	end
	local info = sys.exec("redis-cli INFO 2>/dev/null") or ""
	local function g(k)
		return info:match(k .. ":(.-)\r?\n")
	end
	local out = {
		running = true,
		version = g("redis_version") or "",
		mode = g("redis_mode") or "",
		port = g("tcp_port") or "6379",
		pid = g("process_id") or "",
		uptime_redis = tonumber(g("uptime_in_seconds") or "0") or 0,
		connected_clients = tonumber(g("connected_clients") or "0") or 0,
		used_memory_rss_human = g("used_memory_rss_human") or "",
		db_keys = 0
	}
	local db0 = info:match("db0:(.-)\r?\n")
	if db0 then
		out.db_keys = tonumber(db0:match("keys=(%d+)")) or 0
	end
	http.write_json(out)
end

function redis_command()
	local http = require "luci.http"
	local sys = require "luci.sys"
	local cmd = http.formvalue("cmd") or "PING"
	local db = http.formvalue("db") or "0"
	http.prepare_content("application/json")
	local result = sys.exec("redis-cli -n " .. db .. " " .. cmd .. " 2>&1") or ""
	http.write_json({result = result, output = result})
end

function redis_action()
	local http = require "luci.http"
	local sys = require "luci.sys"
	local action = http.formvalue("action") or "start"
	sys.call("/etc/init.d/redis " .. action .. " >/dev/null 2>&1")
	os.execute("sleep 1")
	local rc = sys.call("redis-cli -n 0 ping >/dev/null 2>&1")
	http.write_json({result = "ok", action = action, running = (rc == 0)})
end
