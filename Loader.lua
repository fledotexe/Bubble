repeat task.wait() until game:IsLoaded()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

if Bubble and Bubble.Loaded then
    warn("Script is already loaded")
    return
end

local success, response = pcall(function()
    return request({
        Url = "https://apis.roblox.com/universes/v1/places/" .. game.PlaceId .. "/universe",
        Method = "GET"
    })
end)

if success and response and response.Body then
    data = HttpService:JSONDecode(response.Body)
else
    warn("Failed to get universeId from API")
    return
end

local function Loadscript(script)
    local domain = "https://raw.githubusercontent.com/fledotexe/Bubble/request/Games/"
    return loadstring(game:HttpGet(domain .. script .. ".lua"))()
end

getgenv().Bubble = {
    PlaceId = nil,
    Loaded = false,
    Games = {
        [87039211657390]  = {Name = "Arise Crossover", UUID = 7074860883},
        [101949297449238] = {Name = "Build An Island", UUID = 7541395924},
    }
}

for id, game in pairs(Bubble.Games) do
    if data.universeId == game.UUID then
        print("Found supported game:", game.Name)
        Bubble.Loaded = true
        Bubble.PlaceId = id
        Loadscript(id)
    end
end

if not Bubble.Loaded then
    warn("Bubble does not support this game")
    return
end

CoreGui.DescendantAdded:Connect(function(Ins)
    if Ins.Name == "LeaveButton" then
        task.delay(1, function()
            TeleportService:Teleport(Bubble.PlaceId, Players.LocalPlayer)
        end)
    end
end)
