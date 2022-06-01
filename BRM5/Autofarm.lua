local TypeWrite = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/TypeWriter.lua"))()
TypeWrite("AUTOFARM PATCHED\nDONT DM ME\nSOURCE CODE COMMENTED IN THIS SCRIPT",15)

--[[
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Workspace = game:GetService("Workspace")
local NPCFolder = Workspace:FindFirstChild("Bots")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer

local Enabled = false
local AFKPlace = 1
local AFKPlaces = {
    CFrame.new(3853.97021484375, 172.68963623046875, -429.0279541015625), -- City Hall
    CFrame.new(-5125.18359375, 105.015625, 5607.85791015625), -- Iraq
    CFrame.new(-1584.665771484375, 820.1268310546875, -4451.94775390625), -- Mountain Outpost
    CFrame.new(6282.3046875, 125.08175659179688, 2208.153076171875), -- Navalbase
    CFrame.new(469.768310546875, 21.769287109375, 2273.580078125), -- Quary
    CFrame.new(1225.836669921875, 55.94757080078125, -5377.25439453125), -- Power Station
    CFrame.new(6866.8974609375, 181.8929443359375, -1910.042236328125), -- Stronghold
    CFrame.new(497.245361328125, 113.73883056640625, -209.046875) -- Vietnama Village
}

local TypeWrite = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/TypeWriter.lua"))()
if not getloadedmodules then TypeWrite("<font size=\"30\"><font color=\"rgb(252,126,63)\"><b>⚠</b></font></font> your exploit is not supported",15) return end
if #PlayerService:GetPlayers() > 1 then
    TypeWrite("<font size=\"30\"><font color=\"rgb(252,126,63)\"><b>⚠</b></font></font> you have players in this server\nplease use autofarm in free private server",15)
    return
end

-- nice network lib for brm5
local Network = {}
for Index, Table in pairs(getgc(true)) do
    if typeof(Table) == "table"
    and rawget(Table,"FireServer")
    and rawget(Table,"InvokeServer") then
        function Network:FireServer(...)
            Table:FireServer(...)
        end
        function Network:InvokeServer(...)
            Table:InvokeServer(...)
        end
        break
    end
end

-- simple config
if not getgenv().AutofarmConfig then
    getgenv().AutofarmConfig = {
        Keybind = "F6",
        UseSecondaryWeapon = false,
        EnableOptimization = false
    }
end

-- get loaded game module and require it
local function requireGameModule(Name)
    for Index, Instance in pairs(getloadedmodules()) do
        if Instance.Name == Name then
            return require(Instance)
        end
    end
end

-- simple equip gun function which is uses game module
local InventoryService = requireGameModule("InventoryService")
local function equipGun()
    local WeaponId = AutofarmConfig.UseSecondaryWeapon and 2 or 1
    if InventoryService and InventoryService._equipped.id ~= WeaponId then
        InventoryService:_cycle(WeaponId)
    end
end

-- teleport player character to picked cframe
local function teleportCharacter(Target)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        LocalPlayer.Character.HumanoidRootPart.CFrame = Target
    end
end

-- get ammo from ammo box at lobby and use it
-- need to be fired with their network lib
local function getAmmo()
    for Index, Prop in pairs(Terrain:GetChildren()) do
        if Prop:IsA("Attachment") and Prop.WorldPosition == Vector3.new(-4020.118896484375, 63.068824768066406, 804.8662109375) then
            teleportCharacter(Prop.WorldCFrame)
            Network:FireServer("ActivateInteration", Prop:FindFirstChildOfClass("ProximityPrompt").Name)
        end
    end
end

-- simple get npc func with hostages check and health check
local function getTarget()
    for Index, NPC in pairs(NPCFolder:GetChildren()) do
        if not NPC:FindFirstChildWhichIsA("ProximityPrompt",true) then
            if NPC:FindFirstChildOfClass("Humanoid")
            and NPC:FindFirstChildOfClass("Humanoid").Health > 0 then
                teleportCharacter(NPC.HumanoidRootPart.CFrame)
                return NPC.Head
            end
        end
    end
end

-- godmode function (DETECTED AND CAN GET YOU BANNED) (thats why its patched)
--local function godmode()
    --if LocalPlayer.Character and LocalPlayer.Character:WaitForChild("Humanoid") then
        --task.wait(1) equipGun() task.wait(1)
        --local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        --local HumanoidClone = Humanoid:Clone()
        --HumanoidClone.Parent = LocalPlayer.Character
        --Humanoid:Destroy()
    --end
--end

-- main loop
RunService.HeartBeat:Connect(function()
    if Enabled then
        if InventoryService and InventoryService._handler then -- if weapon equiped
            if InventoryService._handler._config.Ammo.active > 1 then -- if enough ammo
                local Target = getTarget() -- get npc
                
                if Target then -- if npc exist
                    local GUID = HttpService:GenerateGUID(false) -- generate guid for weapon shoot event
                    Network:FireServer("ActivateInventory", "Discharge", GUID, 0, {{Target.Position.X,Target.Position.Y,Target.Position.Z}})
                    Network:FireServer("ReplicateBullet", GUID .. "1", Target:GetFullName(), {0,0,0})
                    InventoryService._handler._config.Ammo.active = InventoryService._handler._config.Ammo.active - 1 -- substract one bullet from magazine (to make ammo check work)
                    InventoryService._handlers.Firearm._hud(InventoryService._handler) -- update hud values (ammo, gun image, fire mode)
                else -- if not just teleport to afk place (npc bases)
                    teleportCharacter(AFKPlaces[AFKPlace])
                end
            else
                getAmmo()
            end
        else
            equipGun()
        end
    end
end)

-- loop for afk places
coroutine.wrap(function()
    while task.wait(5) do
        if Enabled then
            if AFKPlace < #AFKPlaces then
                AFKPlace = AFKPlace + 1
            else
                AFKPlace = 1
            end
        end
    end
end)()

-- keybind to enable autofarm
UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode[AutofarmConfig.Keybind] then
        Enabled = not Enabled
        TypeWrite("Autofarm " .. (Enabled and "<font color=\"rgb(128,255,128)\">enabled</font>" or "<font color=\"rgb(255,128,128)\">disabled</font>\n<font size=\"15\">(teleporting to spawn)</font>"),5)
        if not Enabled then
            teleportCharacter(CFrame.new(-4004, 64, 806))
        end
    end
end)

-- anti afk
local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if getnamecallmethod() == "FindService" and 
    (args[1] == "VirtualUser" or args[1] == "VirtualInputManager") and 
    self == game and not checkcaller() then
        return nil
    end
    return __namecall(self, ...)
end)

local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.zero)
end)

-- OPTIMIZATION
-- original by e621 on v3rm (https://v3rmillion.net/showthread.php?tid=975134)
if AutofarmConfig.EnableOptimization then

    -- original by w a e on v3rm (https://v3rmillion.net/showthread.php?tid=1016398)
    --local NetworkSettings = settings():GetService("NetworkSettings")
    --local RenderSettings = settings():GetService("RenderSettings")
    --local UserGameSettings = UserSettings():GetService("UserGameSettings")

    --local Closure = newcclosure or function(Function) return Function end
    --local SetProperty = sethiddenproperty or set_hidden_property or set_hidden_prop or function(Instance, Property, Value) pcall(Closure(function() Instance[Property] = Value end)) end

    --local Configuration = {
        --QualityLevel = Enum.QualityLevel.Level01,
        --SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1,
        --LightingTechnology = Enum.Technology.Legacy,
        --ModelLevelOfDetail = Enum.ModelLevelOfDetail.Disabled,
        --InterpolationThrottlingMode = Enum.InterpolationThrottlingMode.Disabled,
        --MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01,
        --MeshPartHeadsAndAccessories = Enum.MeshPartHeadsAndAccessories.Disabled,
        --EagerBulkExecution = false, -- Rendering budget limit
        --GlobalShadows = false,
        --TerrainDecoration = false,
        --IncomingReplicationLag = -1000,
        --HasEverUsedVR = true,
        --VREnabled = true
    --}

    --spawn(Closure(function()
        --SetProperty(UserGameSettings, "SavedQualityLevel", Configuration["SavedQualityLevel"])
        --SetProperty(UserGameSettings, "HasEverUsedVR", Configuration["HasEverUsedVR"])
        --SetProperty(UserGameSettings, "VREnabled", Configuration["VREnabled"])
        --SetProperty(RenderSettings, "QualityLevel", Configuration["QualityLevel"])
        --SetProperty(RenderSettings, "MeshPartDetailLevel", Configuration["MeshPartDetailLevel"])
        --SetProperty(RenderSettings, "EagerBulkExecution", Configuration["EagerBulkExecution"])
        --SetProperty(NetworkSettings, "IncomingReplicationLag", Configuration["IncomingReplicationLag"])
        --SetProperty(Lighting, "GlobalShadows", Configuration["GlobalShadows"])
        --SetProperty(Lighting, "Technology", Configuration["LightingTechnology"])
        --SetProperty(workspace.Terrain, "Decoration", Configuration["TerrainDecoration"])
        --SetProperty(workspace, "LevelOfDetail", Configuration["ModelLevelOfDetail"])
        --SetProperty(workspace, "MeshPartHeadsAndAccessories", Configuration["MeshPartHeadsAndAccessories"])
        --SetProperty(workspace, "InterpolationThrottling", Configuration["InterpolationThrottlingMode"])
    --end))

    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Workspace.Terrain:Clear()

    for Index, Value in pairs(Workspace.Custom:GetChildren()) do
        if Value.Name ~= "0" then
            Value:Destroy()
        end
    end
    for Index, Value in pairs(Workspace.Custom["0"]:GetChildren()) do
        if Value.Name ~= "FOB" then
            Value:Destroy()
        end
    end

    Lighting.GlobalShadows = false
    Lighting.FogEnd = math.huge
    Lighting.Brightness = 0

    for Index,Value in pairs(Lighting:GetChildren()) do
        Value:Destroy()
    end

    for Index, Value in pairs(Workspace:GetDescendants()) do
        if Value:IsA("BasePart") then
            Value.Material = Enum.Material.Plastic
            Value.Reflectance = 0
        elseif Value:IsA("Decal") or Value:IsA("Texture") then
            Value.Transparency = 1
            Value.Texture = ""
        elseif Value:IsA("ParticleEmitter") or Value:IsA("Trail") then
            Value.Lifetime = NumberRange.new(0)
        elseif Value:IsA("Explosion") then
            Value.BlastPressure = 1
            Value.BlastRadius = 1
            Value.Visible = false
        elseif Value:IsA("Fire") or Value:IsA("SpotLight") or Value:IsA("Smoke") or Value:IsA("Sparkles") then
            Value.Enabled = false
        elseif Value:IsA("MeshPart") then
            Value.RenderFidelity = Enum.RenderFidelity.Performance
            Value.TextureID = ""
        end
    end
end

--godmode()
--LocalPlayer.CharacterAdded:Connect(function()
    --godmode()
--end)

TypeWrite("Autofarm by AlexR32#0157\nDont use shotguns\nIf you are in menu press Deploy\nPress " .. AutofarmConfig.Keybind .. " to start farming",15)
]]
