local folder = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])")
local library = folder .. "FuzzyGuard.dll"
local toggle = assert(package.loadlib(library, "luaopen_fuzzy_toggle"))
local reset = assert(package.loadlib(library, "luaopen_fuzzy_reset"))
assert(package.loadlib(library, "luaopen_fuzzy_panel"))()
RegisterKeyBind(Key.F7, function() ExecuteInGameThread(function() toggle() end) end)
RegisterKeyBind(Key.F8, function() ExecuteInGameThread(function() reset() end) end)
print("[FuzzyGuard] F6 status panel; F7 toggle inside training; F8 rearm")

local probe = assert(package.loadlib(library, "luaopen_fuzzy_probe"))
if type(LoopInGameThreadWithDelay) == "function" then
    LoopInGameThreadWithDelay(500, function() probe(); return false end)
else
    LoopAsync(500, function() ExecuteInGameThread(function() probe() end); return false end)
end
