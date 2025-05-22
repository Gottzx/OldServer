local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local placeId = game.PlaceId

local function getOldServers()
    local servers = {}
    local cursor = ""
    repeat
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end

        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if success and result and result.data then
            for _, server in pairs(result.data) do
                if server.maxPlayers == 6 and server.playing < server.maxPlayers then
                    table.insert(servers, server)
                end
            end
            cursor = result.nextPageCursor or ""
        else
            warn("โหลดเซิร์ฟเวอร์ไม่สำเร็จ")
            break
        end
    until cursor == "" or #servers > 0

    return servers
end

local function teleportToOldServer()
    local oldServers = getOldServers()
    if #oldServers > 0 then
        local targetServer = oldServers[math.random(1, #oldServers)]
        TeleportService:TeleportToPlaceInstance(placeId, targetServer.id, player)
    else
        warn("ไม่เจอเซิร์ฟเวอร์ที่ maxPlayers = 6")
    end
end

teleportToOldServer()
