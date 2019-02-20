

local skynet = require "skynet"
local cluster = require "skynet.cluster"
local snax = require "skynet.snax"
local traceback = debug.traceback

local function __init__()
    skynet.newservice("debug_console",8000)

    skynet.uniqueservice(true, "monitor")

    local harbor = skynet.newservice("harbor")
    skynet.call(harbor, "lua", "open")

    local sdb = skynet.newservice("simpledb")
    cluster.register("sdb", sdb)

    print(skynet.call(sdb, "lua", "SET", "a", "foobar"))
    print(skynet.call(sdb, "lua", "SET", "b", "foobar2"))
    print(skynet.call(sdb, "lua", "SET", "c", "foobar3"))
    print(skynet.call(sdb, "lua", "SET", "d", "foobar4"))

    print(skynet.call(sdb, "lua", "GET", "a"))
    print(skynet.call(sdb, "lua", "GET", "b"))
    print(skynet.call(sdb, "lua", "GET", "c"))
    print(skynet.call(sdb, "lua", "GET", "d"))

    cluster.open "db"
    cluster.open "db2"
    cluster.open "db3"
    cluster.open "db4"
    cluster.open "db5"

    snax.uniqueservice "pingserver"
end

skynet.start(__init__)