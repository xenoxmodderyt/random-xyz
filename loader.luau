-- Taha's Universal Keyless Bypass v2.0
-- Full Code provided - no redactions.

-- 1. Notification Helper
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 5,
        Button1 = "OK"
    })
    print("[" .. title .. "] " .. text)
end

-- 2. Environmental Setup
if not game:IsLoaded() then game.Loaded:Wait() end
Notify("Taha Bypass", "Scanning Game ID and initializing...")

-- 3. The Original Game ID Mapping (Restored and Corrected)
local gameTable = {
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

local currentGame = gameTable[game.GameId]
if not currentGame then 
    Notify("Bypass Error", "This specific game is not in the supported list.")
    return 
end

-- 4. Global Interception (Hooking)
getgenv().script_key = "TAHA_BYPASS_PERMANENT"

local old_loadstring
old_loadstring = hookfunction(loadstring, function(code)
    -- This intercepts the Luarmor library regardless of which game script calls it
    if type(code) == "string" and (code:find("luarmor") or code:find("check_key")) then
        local lib = old_loadstring(code)()
        
        if type(lib) == "table" and lib.check_key then
            lib.check_key = function(key)
                Notify("Bypass System", "Authentication spoofed for " .. game.Name)
                return {code = 'KEY_VALID', message = 'Bypassed by Taha'}
            end
        end
        return function() return lib end
    end
    return old_loadstring(code)
end)

-- 5. Execution Logic (Handles v3 and v4 redirection)
local function ExecutePayload(targetUrl)
    local success, content = pcall(function() return game:HttpGet(targetUrl) end)
    if not success then
        Notify("Download Error", "Could not reach Luarmor servers.")
        return
    end

    -- Check if this is a redirection script (like the one you found)
    if content:find("v4/loaders") then
        local v4Url = content:match('"(https://api.luarmor.net/files/v4/loaders/[%w%.]+)"')
        if v4Url then
            Notify("Redirection", "Jumping to v4 secure payload...")
            loadstring(game:HttpGet(v4Url))()
            return
        end
    end

    -- Otherwise, execute the v3 content directly
    Notify("Injecting", "Running game script...")
    loadstring(content)()
end

ExecutePayload(currentGame.Url)
