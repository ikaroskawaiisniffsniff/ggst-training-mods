local source = debug.getinfo(1, "S").source
local scripts = source:sub(2):match("^(.*[/\\])")
local library = scripts .. "SF6ReversalDelay.dll"

local init, init_error = package.loadlib(library, "luaopen_reversal_delay")
if not init then
    print("[SF6ReversalDelay] " .. tostring(init_error))
    return
end
init()

local tick, tick_error = package.loadlib(library, "luaopen_reversal_delay_tick")
if not tick then
    print("[SF6ReversalDelay] " .. tostring(tick_error))
    return
end

local function update()
    tick()
    return false
end

if type(LoopInGameThreadWithDelay) == "function" then
    LoopInGameThreadWithDelay(50, update)
else
    LoopAsync(50, function()
        ExecuteInGameThread(update)
        return false
    end)
end

print("[SF6ReversalDelay] loaded")
