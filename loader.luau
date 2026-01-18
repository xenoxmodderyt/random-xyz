-- Kicia Hook Keyless Bypass - Verbatim Patched Source
-- For Educational Purposes Only

-- 1. Setup Environment
if getfenv(2).script_key then getgenv().script_key = getfenv(2).script_key end
if not game:IsLoaded() then game.Loaded:Wait() end

-- 2. Configuration & ID Mapping
local b = {
    [7018190066] = {Url = [[https://api.luarmor.net/files/v3/loaders/f442f580304e53e183560ff4cfd715fc.lua]]},
    [7436755782] = {Url = [[https://api.luarmor.net/files/v3/loaders/b7d180acad508c48c140afe43d01ea0c.lua]]},
    [7178032757] = {Url = [[https://api.luarmor.net/files/v3/loaders/2e6b46bc05af83e8427cd9b5123bba27.lua]]},
    [6035872082] = {Url = [[https://api.luarmor.net/files/v3/loaders/63d0cd967eb525cdc489809d1537b356.lua]]},
    [245662005]  = {Url = [[https://api.luarmor.net/files/v3/loaders/c7c92198fe99e9b6ea44f3601c77225d.lua]]},
    [994732206]  = {Url = [[https://api.luarmor.net/files/v3/loaders/35da3a3a92dd3b65f8d20528035fc94c.lua]]},
    [5166944221] = {Url = [[https://api.luarmor.net/files/v3/loaders/023ba9954f152b29a924c57cf1e83053.lua]]},
    [66654135]   = {Url = [[https://api.luarmor.net/files/v3/loaders/24e8cf30a21a49dc9f91b2856f04cd5a.lua]]},
    [115797356]  = {Url = [[https://api.luarmor.net/files/v3/loaders/296e5f51cf7ad143111cfe011ce26503.lua]]}
}

local c = b[game.GameId]
if not c then 
    print("Game not supported by loader.")
    return 
end

-- 3. The Execution Function
local d = function()
    pcall(function()
        if setthreadidentity then setthreadidentity(8) end
    end)
    print("Fetching payload from: " .. c.Url)
    loadstring(game:HttpGet(c.Url))()
end

-- 4. Luarmor SDK Emulation (The Bypass)
-- We load the real library but immediately hook the check function
local g = loadstring(game:HttpGet('https://sdkapi-public.luarmor.net/library.lua'))()
g.script_id = c.Url:split('/')[7]:sub(1, -5)

-- Force g.check_key to always return 'KEY_VALID'
g.check_key = function(key)
    print("Bypass: Emulating valid key response for " .. tostring(key))
    return {code = 'KEY_VALID'}
end

-- 5. Final Jump
print("Bypass Active. Starting cheat...")
script_key = "TAHA_BYPASS_V1" -- Placeholder for internal scripts that require the variable
d()