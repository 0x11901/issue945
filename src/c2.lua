

local skynet = require "skynet"
local cluster = require "skynet.cluster"

local function __init__()
    skynet.newservice("debug_console",8001)

    local harbor = skynet.newservice("harbor")
    skynet.call(harbor, "lua", "open")

    local proxy = cluster.proxy "db@sdb"    -- cluster.proxy("db", "@sdb")
    local largekey = string.rep("X", 128 * 1024)
    local largevalue = string.rep("R", 100 * 1024)
    skynet.call(proxy, "lua", "SET", largekey, largevalue)
    local v = skynet.call(proxy, "lua", "GET", largekey)
    assert(largevalue == v)
    skynet.send(proxy, "lua", "PING", "proxy")

    skynet.fork(function()
        skynet.trace("cluster")
        print(cluster.call("db", "@sdb", "GET", "a"))
        print(cluster.call("db2", "@sdb", "GET", "b"))
        print(cluster.call("db3", "@sdb", "GET", "c"))
        print(cluster.call("db4", "@sdb", "GET", "d"))
        cluster.send("db5", "@sdb", "PING", "db2:longstring" .. largevalue)
    end)
end

skynet.start(__init__)