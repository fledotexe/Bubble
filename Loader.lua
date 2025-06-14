repeat task.wait() until game:IsLoaded()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

if Bubble and Bubble.Loaded then
    warn("[Bubble] Script is already loaded")
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
    warn("[Bubble] Failed to get universeId from API")
    return
end

local function Loadscript(Script)
    local Domain = "https://fl3.netlify.app/games/"
    return loadstring(game:HttpGet(Domain .. Script .. ".lua"))()
end

getgenv().Bubble = {
    Loaded = false,
    Games = {
        [87039211657390] = {Name = "Arise Crossover", UUID = 7074860883},
    }
}

for id, game in pairs(Bubble.Games) do
    if data.universeId == game.UUID then
        print("[Bubble] Found supported game:", game.Name)
        Loadscript(id)
        Bubble.Loaded = true
        PlaceId = id
    else
        warn("[Bubble] We do not support this game")
        return
    end
end

CoreGui.DescendantAdded:Connect(function(Ins)
    if Ins.Name == "LeaveButton" then
        task.delay(1, function()
            TeleportService:Teleport(PlaceId, Players.LocalPlayer)
        end)
    end
end)