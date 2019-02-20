

local skynet = require "skynet"
local traceback = debug.traceback
local tool = require "common.tool"

local harbor = {}

function harbor.open(addr)
    local monitor = skynet.queryservice(true, "monitor")
    skynet.call(monitor, "lua", "register", tool.guid())
end

function harbor.close()
    skynet.exit()
end

function harbor.heart_beat()
    print("--- heartbeat harbor")
end

local function __init__()
    skynet.dispatch("lua", function(_, source, command, ...)
        local f = harbor[command]
        if not f then
            print(string.format("unhandled message(%s)", command))
            return skynet.ret()
        end

        local ok, ret = xpcall(f, traceback, source, ...)
        if not ok then
            print(string.format("handle message(%s) failed : %s", command, ret))
            return skynet.ret()
        end
        skynet.retpack(ret)
    end)
end

skynet.start(__init__)