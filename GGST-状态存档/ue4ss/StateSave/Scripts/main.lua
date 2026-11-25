local source = debug.getinfo(1, "S").source
local scripts = source:sub(2):match("^(.*[/\\])")
local library = scripts .. "StateSave.dll"

local init, init_error = package.loadlib(library, "luaopen_state_save")
if not init then
    print("[StateSave] " .. tostring(init_error))
    return
end
init()

local tick, tick_error = package.loadlib(library, "luaopen_state_save_tick")
if not tick then
    print("[StateSave] " .. tostring(tick_error))
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

print("[StateSave] loaded")
