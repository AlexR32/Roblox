repeat task.wait() until game.GameId ~= 0
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/TypeWriter.lua"))()

local Games = {
    ["1054526971"] = {
        Name = "Blackhawk Rescue Mission 5",
        Script = "https://raw.githubusercontent.com/AlexR32/Roblox/main/BRM5/SilentAim.lua"
    },
    ["580765040"] = {
        Name = "RAGDOLL UNIVERSE",
        Script = "https://raw.githubusercontent.com/AlexR32/Roblox/main/Ragdoll%20Mayhem/MultiHack.lua"
    },
    ["1168263273"] = {
        Name = "Bad Business",
        Script = "https://raw.githubusercontent.com/AlexR32/Roblox/main/BadBusiness/Multihack.lua"
    }
}

local function returnGameInfo()
    for Id,Info in pairs(Games) do
        if tostring(game.GameId) == Id then
            return Info
        end
    end
end

local Info = returnGameInfo()
if Info then
    NotifyLib:Notification("Parvus Hub",Info.Name .. " script loaded!",5)
    loadstring(game:HttpGet(Info.Script))()
else
    NotifyLib:Notification("Parvus Hub","nothing to load here, sorry",5)
end
