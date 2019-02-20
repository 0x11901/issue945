
local skynet = require "skynet"
local xpcall = xpcall
local traceback = debug.traceback

local interval_time = 5 * 100
local node_map = {}
local name_map = {}

local monitor = {}
function monitor.register(addr, node_id, node_name)
    assert(node_id ~= nil, "Invalid arguments: ID")
    if node_name ~= nil then
        name_map[node_id] = node_name
    end
    node_map[addr] = node_id
end

local function service_dump(node_id)
    local id = name_map[node_id]
    if id == nil then
        id = node_id
    end
    print(string.format("--- node 【%s】 dump!", id))
end

local function call_service(addr)
    skynet.call(addr, "lua", "heart_beat")
end

local function heart_beat_scheduler()
    print("---------- 【heart beat begin】 ----------")
    for k, v in pairs(node_map) do
        local ok, _ = xpcall(call_service, traceback, k)
        if not ok then
            service_dump(v)
            node_map[k] = nil
            name_map[v] = nil
        else
            print(string.format("--- node running:【%s】, addr:%x", v, k))
        end
    end
    print("---------- 【heart beat end】 ----------")

    skynet.timeout(interval_time, heart_beat_scheduler)
end

local function __init__()
    print("--- monitor addr:", skynet.self())

    skynet.timeout(interval_time, heart_beat_scheduler)
    skynet.dispatch("lua", function(_, addr, command, ...)
        local f = monitor[command]
        if not f then
            print(string.format("unhandled message(%s)", command))
            return skynet.ret()
        end

        local ok, ret = xpcall(f, traceback, addr, ...)
        if not ok then
            print(string.format("handle message(%s) failed : %s", command, ret))
            return skynet.ret()
        end
        skynet.retpack(ret)
    end)
end

skynet.start(__init__)