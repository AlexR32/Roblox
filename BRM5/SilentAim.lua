repeat task.wait() until game.IsLoaded
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/TypeWriter.lua"))()
if getgenv().MultihackExecuted then NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> script already executed",15,0) return end
getgenv().MultihackExecuted = true

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer
local Camera = Workspace.CurrentCamera

local Target = nil
local Aimbot = false
local GroundTip = nil
local AircraftTip = nil

if not LocalPlayer then
    NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> cant find localplayer, making finding loop...",15,0)
    while task.wait() do
        if PlayerService.LocalPlayer then
            NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> localplayer founded",15,0)
            LocalPlayer = PlayerService.LocalPlayer
            break
        end
    end
end
LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> queue on teleport started",15,0)
        getgenv().MultihackExecuted = false
        local QueueOnTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport
        QueueOnTeleport(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/BRM5/SilentAim.lua"))
    end
end)
local NPCFolder = Workspace:FindFirstChild("Enemies")
if not NPCFolder then
    NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> cant find enemies, making finding loop...\nyou are probably not in openworld",15,0)
    while task.wait() do
        if Workspace:FindFirstChild("Enemies") then
            NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> enemies founded",15,0)
            NPCFolder = Workspace:FindFirstChild("Enemies")
            break
        end
    end
end

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/ESPLibrary.lua"))()
local ConfigSystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/ConfigSystem.lua"))()

local function SaveConfig()
    if isfile("Alex's Scripts/BRM5_SilentAim.json") then
        ConfigSystem.WriteJSON(Config,"Alex's Scripts/BRM5_SilentAim.json")
    else
        makefolder("Alex's Scripts")
        ConfigSystem.WriteJSON(Config,"Alex's Scripts/BRM5_SilentAim.json")
    end
end
local function LoadConfig()
    if isfile("Alex's Scripts/BRM5_SilentAim.json") then
        getgenv().Config = ConfigSystem.ReadJSON("Alex's Scripts/BRM5_SilentAim.json",Config)
    else
        makefolder("Alex's Scripts")
        ConfigSystem.WriteJSON(Config,"Alex's Scripts/BRM5_SilentAim.json")
    end
end

getgenv().Config = {
    UI = {
        Enabled = true,
        Keybind = "RightShift",
        Color = Color3.fromRGB(255,128,64),
        Background = "Floral",
        BackgroundId = "rbxassetid://5553946656",
        BackgroundColor = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0
    },

    -- ESP
    PlayerESP = {
        AllyColor = Color3.fromRGB(64,255,64),
        EnemyColor = Color3.fromRGB(255,64,64),

        HeadCircleVisible = false,
        HeadCircleFilled = true,
        HeadCircleRadius = 4,
        HeadCircleNumSides = 4,

        IsEnemy = false,
        TeamColor = false,
        BoxVisible = false,
        TextVisible = false,
        TextSize = 16
    },
    NPCESP = {
        EnemyColor = Color3.fromRGB(255,64,64),

        HeadCircleVisible = false,
        HeadCircleFilled = true,
        HeadCircleRadius = 4,
        HeadCircleNumSides = 4,

        BoxVisible = false,
        TextVisible = false,
        Name = "Enemy NPC",
        TextSize = 16
    },

    Binds = {
        Aimbot = "NONE",
        SilentAim = "NONE",
        RapidFire = "NONE",
        Speedhack = "NONE",
        Vehicle = "NONE",
        Helicopter = "NONE"
    },

    -- Circle
    Circle = {
        Visible = true,
        Transparency = 1,
        Color = Color3.fromRGB(255,128,64),
        Thickness = 1,
        NumSides = 100,
        Filled = false
    },

    -- Aimbot
    SilentAim = true,
    SAMode = "Gun",
    Wallcheck = false,

    -- Aimbot Settings
    Sensitivity = 0.5,
    FieldOfView = 100,
    TargetMode = "NPC",
    AimHitbox = "Head",

    -- Other
    EnvEnable = false,
    EnvTime = 12,
    EnvBrightness = 2,
    EnvFog = 0.25,

    NoRecoil = false,
    InstantHit = false,
    UnlockFiremodes = false,
    RapidFire = false,
    RapidFireValue = 1000,

    Speedhack = false,
    SpeedhackValue = 32,

    Vehicle = false,
    VehicleSpeed = 60,
    VehicleAcceleration = 1,

    Helicopter = false,
    HelicopterSpeed = 200
}
LoadConfig()

local Library = loadstring(game:GetObjects("rbxassetid://7974127463")[1].Source)()
local Window = Library({Name = "Blackhawk Rescue Mission 5 Multihack",Enabled = Config.UI.Enabled,Color = Config.UI.Color,Position = UDim2.new(0.2,-248,0.5,-248)}) do
    local MainTab = Window:AddTab({Name = "Main"}) do
        local AimbotSection = MainTab:AddSection({Name = "Aim Assist",Side = "Left"}) do
            AimbotSection:AddBind({Name = "Aimbot",Key = Config.Binds.Aimbot,Mouse = true,Callback = function(Bool,Key)
                Config.Binds.Aimbot = Key or "NONE"
                Aimbot = Bool
            end})
            AimbotSection:AddToggle({Name = "Silent Aim",Value = Config.SilentAim,Callback = function(Bool)
                Config.SilentAim = Bool
            end}):AddBind({Key = Config.Binds.SilentAim,Mouse = true,Callback = function(Bool,Key)
                Config.Binds.SilentAim = Key or "NONE"
            end})
            AimbotSection:AddToggle({Name = "Wallcheck",Value = Config.Wallcheck,Callback = function(Bool)
                Config.Wallcheck = Bool
            end})
            AimbotSection:AddSlider({Name = "Sensitivity",Min = 0,Max = 1,Precise = 2,Value = Config.Sensitivity,Callback = function(Number)
                Config.Sensitivity = Number
            end})
            AimbotSection:AddSlider({Name = "Field Of View",Min = 0,Max = 500,Value = Config.FieldOfView,Callback = function(Number)
                Config.FieldOfView = Number
            end})
            AimbotSection:AddDropdown({Name = "Silent Aim Mode",Default = Config.SAMode,List = {"Gun", "Turret", "Aircraft"},Callback = function(String)
                Config.SAMode = String
            end})
            AimbotSection:AddDropdown({Name = "Target",Default = Config.TargetMode,List = {"NPC", "Player"},Callback = function(String)
                Config.TargetMode = String
            end})
            AimbotSection:AddDropdown({Name = "Hitbox",Default = Config.AimHitbox,List = {"Head", "HumanoidRootPart"},Callback = function(String)
                Config.AimHitbox = String
            end})
        end
        local NPCESPSection = MainTab:AddSection({Name = "NPC ESP",Side = "Left"}) do
            NPCESPSection:AddColorpicker({Name = "Color",Color = Config.NPCESP.EnemyColor,Callback = function(Color)
                Config.NPCESP.EnemyColor = Color
            end})
            NPCESPSection:AddToggle({Name = "Box",Value = Config.NPCESP.BoxVisible,Callback = function(Bool)
                Config.NPCESP.BoxVisible = Bool
            end})
            NPCESPSection:AddToggle({Name = "Text",Value = Config.NPCESP.TextVisible,Callback = function(Bool)
                Config.NPCESP.TextVisible = Bool
            end})
            NPCESPSection:AddSlider({Name = "Text Size",Min = 14,Max = 30,Value = Config.NPCESP.TextSize,Callback = function(Number)
                Config.NPCESP.TextSize = Number
            end})
            NPCESPSection:AddTextbox({Name = "NPC Name",Text = Config.NPCESP.Name,Placeholder = "NPC Name",Callback = function(String)
                Config.NPCESP.Name = String
            end})
            NPCESPSection:AddDivider({Text = "Head Circle"})
            NPCESPSection:AddToggle({Name = "Enable",Value = Config.NPCESP.HeadCircleVisible,Callback = function(Bool)
                Config.NPCESP.HeadCircleVisible = Bool
            end})
            NPCESPSection:AddToggle({Name = "Filled",Value = Config.NPCESP.HeadCircleFilled,Callback = function(Bool)
                Config.NPCESP.HeadCircleFilled = Bool
            end})
            NPCESPSection:AddSlider({Name = "Radius",Min = 1,Max = 10,Value = Config.NPCESP.HeadCircleRadius,Callback = function(Number)
                Config.NPCESP.HeadCircleRadius = Number
            end})
            NPCESPSection:AddSlider({Name = "NumSides",Min = 3,Max = 100,Value = Config.NPCESP.HeadCircleNumSides,Callback = function(Number)
                Config.NPCESP.HeadCircleNumSides = Number
            end})
        end
        local PlayerESPSection = MainTab:AddSection({Name = "Player ESP",Side = "Left"}) do
            PlayerESPSection:AddColorpicker({Name = "Ally Color",Color = Config.PlayerESP.AllyColor,Callback = function(Color)
                Config.PlayerESP.AllyColor = Color
            end})
            PlayerESPSection:AddColorpicker({Name = "Enemy Color",Color = Config.PlayerESP.EnemyColor,Callback = function(Color)
                Config.PlayerESP.EnemyColor = Color
            end})
            PlayerESPSection:AddToggle({Name = "Use Team Color",Value = Config.PlayerESP.TeamColor,Callback = function(Bool)
                Config.PlayerESP.TeamColor = Bool
            end})
            PlayerESPSection:AddToggle({Name = "Team Check",Value = Config.PlayerESP.IsEnemy,Callback = function(Bool)
                Config.PlayerESP.IsEnemy = Bool
            end})
            PlayerESPSection:AddToggle({Name = "Box",Value = Config.PlayerESP.BoxVisible,Callback = function(Bool)
                Config.PlayerESP.BoxVisible = Bool
            end})
            PlayerESPSection:AddToggle({Name = "Text",Value = Config.PlayerESP.TextVisible,Callback = function(Bool)
                Config.PlayerESP.TextVisible = Bool
            end})
            PlayerESPSection:AddSlider({Name = "Text Size",Min = 14,Max = 30,Value = Config.PlayerESP.TextSize,Callback = function(Number)
                Config.PlayerESP.TextSize = Number
            end})
            PlayerESPSection:AddDivider({Text = "Head Circle"})
            PlayerESPSection:AddToggle({Name = "Enable",Value = Config.PlayerESP.HeadCircleVisible,Callback = function(Bool)
                Config.PlayerESP.HeadCircleVisible = Bool
            end})
            PlayerESPSection:AddToggle({Name = "Filled",Value = Config.PlayerESP.HeadCircleFilled,Callback = function(Bool)
                Config.PlayerESP.HeadCircleFilled = Bool
            end})
            PlayerESPSection:AddSlider({Name = "Radius",Min = 1,Max = 10,Value = Config.PlayerESP.HeadCircleRadius,Callback = function(Number)
                Config.PlayerESP.HeadCircleRadius = Number
            end})
            PlayerESPSection:AddSlider({Name = "NumSides",Min = 3,Max = 100,Value = Config.PlayerESP.HeadCircleNumSides,Callback = function(Number)
                Config.PlayerESP.HeadCircleNumSides = Number
            end})
        end
        local CircleSection = MainTab:AddSection({Name = "FoV Circle",Side = "Right"}) do
            CircleSection:AddToggle({Name = "Enable",Value = Config.CircleVisible,Callback = function(Bool)
                Config.CircleVisible = Bool
            end})
            CircleSection:AddToggle({Name = "Filled",Value = Config.CircleFilled,Callback = function(Bool)
                Config.CircleFilled = Bool
            end})
            CircleSection:AddColorpicker({Name = "Color",Color = Config.CircleColor,Callback = function(Color)
                Config.CircleColor = Color
            end})
            CircleSection:AddSlider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Config.CircleTransparency,Callback = function(Number)
                Config.CircleTransparency = Number
            end})
            CircleSection:AddSlider({Name = "Thickness",Min = 1,Max = 10,Value = Config.CircleThickness,Callback = function(Number)
                Config.CircleThickness = Number
            end})
            CircleSection:AddSlider({Name = "NumSides",Min = 3,Max = 100,Value = Config.CircleNumSides,Callback = function(Number)
                Config.CircleNumSides = Number
            end})
        end
        local OtherSection = MainTab:AddSection({Name = "Other",Side = "Right"}) do
            OtherSection:AddDivider({Text = "Environment"})
            OtherSection:AddToggle({Name = "Enable",Value = Config.EnvEnable,Callback = function(Bool)
                Config.EnvEnable = Bool
            end})
            OtherSection:AddSlider({Name = "Clock Time",Min = 0,Max = 24,Value = Config.EnvTime,Callback = function(Number)
                Config.EnvTime = Number
            end})
            OtherSection:AddSlider({Name = "Brightness",Min = 0,Max = 10,Value = Config.EnvBrightness,Callback = function(Number)
                Config.EnvBrightness = Number
            end})
            OtherSection:AddSlider({Name = "Fog Density",Min = 0,Max = 1,Value = Config.EnvFog,Precise = 2,Callback = function(Number)
                Config.EnvFog = Number
            end})
            OtherSection:AddDivider({Text = "Weapon"})
            OtherSection:AddToggle({Name = "No Recoil",Value = Config.NoRecoil,Callback = function(Bool)
                Config.NoRecoil = Bool
            end})
            OtherSection:AddToggle({Name = "Instant Hit",Value = Config.InstantHit,Callback = function(Bool)
                Config.InstantHit = Bool
            end}):AddToolTip("silent aim works better with it")
            OtherSection:AddToggle({Name = "Unlock Firemodes",Value = Config.UnlockFiremodes,Callback = function(Bool)
                Config.UnlockFiremodes = Bool
            end}):AddToolTip("re-equip your weapon to make it work")
            OtherSection:AddToggle({Name = "Rapid Fire",Value = Config.RapidFire,Callback = function(Bool)
                Config.RapidFire = Bool
            end}):AddBind({Key = Config.Binds.RapidFire,Callback = function(Bool,Key)
                Config.Binds.RapidFire = Key or "NONE"
            end})
            OtherSection:AddSlider({Name = "Round Per Minute",Min = 45,Max = 1000,Value = Config.RapidFireValue,Callback = function(Number)
                Config.RapidFireValue = Number
            end})
            OtherSection:AddDivider({Text = "Character"})
            OtherSection:AddToggle({Name = "Speedhack",Value = Config.Speedhack,Callback = function(Bool)
                Config.Speedhack = Bool
            end}):AddBind({Key = Config.Binds.Speedhack,Callback = function(Bool,Key)
                Config.Binds.Speedhack = Key or "NONE"
            end})
            OtherSection:AddSlider({Name = "Speed",Min = 16,Max = 1000,Value = Config.SpeedhackValue,Callback = function(Number)
                Config.SpeedhackValue = Number
            end})
            OtherSection:AddDivider({Text = "Vehicle Settings"})
            OtherSection:AddToggle({Name = "Enable",Value = Config.Vehicle,Callback = function(Bool)
                Config.Vehicle = Bool
            end}):AddBind({Key = Config.Binds.Vehicle,Callback = function(Bool,Key)
                Config.Binds.Vehicle = Key or "NONE"
            end})
            OtherSection:AddSlider({Name = "Speed",Min = 0,Max = 1000,Value = Config.VehicleSpeed,Callback = function(Number)
                Config.VehicleSpeed = Number
            end})
            OtherSection:AddSlider({Name = "Acceleration",Min = 1,Max = 50,Value = Config.VehicleAcceleration,Callback = function(Number)
                Config.VehicleAcceleration = Number
            end}):AddToolTip("lower = faster")
            OtherSection:AddDivider({Text = "Helicopter Settings"})
            OtherSection:AddToggle({Name = "Enable",Value = Config.Helicopter,Callback = function(Bool)
                Config.Helicopter = Bool
            end}):AddBind({Key = Config.Binds.Helicopter,Callback = function(Bool,Key)
                Config.Binds.Helicopter = Key or "NONE"
            end})
            OtherSection:AddSlider({Name = "Speed",Min = 0,Max = 500,Value = Config.HelicopterSpeed,Callback = function(Number)
                Config.HelicopterSpeed = Number
            end})
        end
    end
    local SettingsTab = Window:AddTab({Name = "Settings"}) do
        local MenuSection = SettingsTab:AddSection({Name = "Menu",Side = "Left"}) do
            MenuSection:AddToggle({Name = "Enabled",Value = Window.Enabled,Callback = function(Bool) 
                Window:Toggle(Bool)
            end}):AddBind({Key = Config.UI.Keybind,Callback = function(Bool,Key)
                Config.UI.Keybind = Key or "NONE"
            end})
            MenuSection:AddToggle({Name = "Close On Exec",Value = not Config.UI.Enabled,Callback = function(Bool) 
                Config.UI.Enabled = not Bool
            end})
            MenuSection:AddColorpicker({Name = "Color",Color = Window.Color,Callback = function(Color)
                Config.UI.Color = Color
                Window:ChangeColor(Color)
            end})
        end
        SettingsTab:AddButton({Name = "Server Hop",Side = "Left",Callback = function()
            -- Credits to Infinite Yield for serverhop
            local x = {}
            for _, v in ipairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
                if type(v) == "table" and v.id ~= game.JobId then
                    x[#x + 1] = v.id
                end
            end
            if #x > 0 then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
            else
                return NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> couldn't find a server",15,0)
            end
        end})
        SettingsTab:AddButton({Name = "Join Discord Server",Side = "Left",Callback = function()
            local Request = (syn and syn.request) or request
            Request({
                ["Url"] = "http://localhost:6463/rpc?v=1",
                ["Method"] = "POST",
                ["Headers"] = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                ["Body"] = HttpService:JSONEncode({
                    ["cmd"] = "INVITE_BROWSER",
                    ["nonce"] = string.lower(HttpService:GenerateGUID(false)),
                    ["args"] = {
                        ["code"] = "JKywVqjV6m"
                    }
                })
            })
        end}):AddToolTip("Join for support, updates and more!")
        local BackgroundSection = SettingsTab:AddSection({Name = "Background",Side = "Right"}) do
            BackgroundSection:AddDropdown({Name = "Image",Default = Config.UI.Background,
            List = {"Legacy","Hearts","Abstract","Hexagon","Circles","Lace With Flowers","Floral"},
            Callback = function(String)
                -- Credits to Jan for cool patterns <3
                Config.UI.Background = String
                if String == "Legacy" then
                    Window.Background.Image = "rbxassetid://2151741365"
                    Config.UI.BackgroundId = "rbxassetid://2151741365"
                elseif String == "Hearts" then
                    Window.Background.Image = "rbxassetid://6073763717"
                    Config.UI.BackgroundId = "rbxassetid://6073763717"
                elseif String == "Abstract" then
                    Window.Background.Image = "rbxassetid://6073743871"
                    Config.UI.BackgroundId = "rbxassetid://6073743871"
                elseif String == "Hexagon" then
                    Window.Background.Image = "rbxassetid://6073628839"
                    Config.UI.BackgroundId = "rbxassetid://6073628839"
                elseif String == "Circles" then
                    Window.Background.Image = "rbxassetid://6071579801"
                    Config.UI.BackgroundId = "rbxassetid://6071579801"
                elseif String == "Lace With Flowers" then
                    Window.Background.Image = "rbxassetid://6071575925"
                    Config.UI.BackgroundId = "rbxassetid://6071575925"
                elseif String == "Floral" then
                    Window.Background.Image = "rbxassetid://5553946656"
                    Config.UI.BackgroundId = "rbxassetid://5553946656"
                end
            end})
            BackgroundSection:AddTextbox({Name = "Custom Image",Text = "",Placeholder = "rbxassetid://ImageId",Callback = function(String)
                Window.Background.Image = String
                Config.UI.BackgroundId = String
            end})
            Window.Background.Image = Config.UI.BackgroundId
            Window.Background.ImageColor3 = Config.UI.BackgroundColor
            BackgroundSection:AddColorpicker({Name = "Color",Color = Window.Background.ImageColor3,Callback = function(Color)
                Config.UI.BackgroundColor = Color
                Window.Background.ImageColor3 = Color
            end})
            Window.Background.ImageTransparency = Config.UI.BackgroundTransparency
            BackgroundSection:AddSlider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Window.Background.ImageTransparency,Callback = function(Number)
                Config.UI.BackgroundTransparency = Number
                Window.Background.ImageTransparency = Number
            end})
            BackgroundSection:AddSlider({Name = "Tile Offset",Min = 74, Max = 296,Value = Window.Background.TileSize.X.Offset,Callback = function(Number)
                Window.Background.TileSize = UDim2.new(0,Number,0,Number)
            end})
            BackgroundSection:AddSlider({Name = "Tile Scale",Min = 0, Max = 1,Precise = 2,Value = Window.Background.TileSize.X.Scale,Callback = function(Number)
                Window.Background.TileSize = UDim2.new(Number,0,Number,0)
            end})
        end
        local CreditsSection = SettingsTab:AddSection({Name = "Credits",Side = "Right"}) do
            CreditsSection:AddLabel({Text = "Thanks to Jan For This Awesome Patterns"})
            CreditsSection:AddLabel({Text = "Thanks to Infinite Yield Team For Server Hop"})
            CreditsSection:AddLabel({Text = "Thanks to coasts For His Univeral ESP/Visuals\n(Forked and remade to module)"})
            CreditsSection:AddLabel({Text = "Thanks to el3tric for Bracket V2\n(Remade to Bracket V3.1)"})
            CreditsSection:AddLabel({Text = "And AlexR32#0157 (Me) For Making This Awesome Script!"})
            CreditsSection:AddLabel({Text = "\xE2\x9D\xA4 \xE2\x9D\xA4 \xE2\x9D\xA4 \xE2\x9D\xA4"})
        end
    end
end

local function TeamCheck(Target)
    if LocalPlayer.Team == Target.Team then
        return false
    end
    return true
end

local function Wallcheck(Part)
    if Config.Wallcheck and Part then
        local Camera = Workspace.CurrentCamera
        local RaycastParameters = RaycastParams.new()
        RaycastParameters.FilterType = Enum.RaycastFilterType.Blacklist
        RaycastParameters.FilterDescendantsInstances = {LocalPlayer.Character,Part.Parent}
        RaycastParameters.IgnoreWater = true
        
        if Workspace:Raycast(Camera.CFrame.Position, (Part.Position - Camera.CFrame.Position), RaycastParameters) then
            return false
        end
    end
    return true
end

local function GetTarget()
    local ClosestTarget = nil
    local FarthestDistance = Config.FieldOfView
    local Camera = Workspace.CurrentCamera

    if Config.TargetMode == "NPC" then
        for Index, Target in pairs(NPCFolder:GetChildren()) do
            local Hitbox = Target:FindFirstChild(Config.AimHitbox) or (Target:IsA("Model") and Target.PrimaryPart)
            local Health = Target:FindFirstChildOfClass("Humanoid") and Target:FindFirstChildOfClass("Humanoid").Health > 0
            if Hitbox and Health then
                local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
                local MouseDistance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                if OnScreen and MouseDistance < FarthestDistance and Wallcheck(Hitbox) then
                    FarthestDistance = MouseDistance
                    ClosestTarget = Hitbox
                end
            end
        end
    elseif Config.TargetMode == "Player" then
        for Index, Target in pairs(PlayerService:GetPlayers()) do
            local Character = Target.Character
            local Hitbox = Character and Character:FindFirstChild(Config.AimHitbox) or Character and (Character:IsA("Model") and Character.PrimaryPart)
            local Health = Character and Character:FindFirstChildOfClass("Humanoid") and Character:FindFirstChildOfClass("Humanoid").Health > 0
            if Hitbox and Health and TeamCheck(Target) then
                local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
                local MouseDistance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                if OnScreen and MouseDistance < FarthestDistance and Wallcheck(Hitbox) then
                    FarthestDistance = MouseDistance
                    ClosestTarget = Hitbox
                end
            end
        end
    end
    
    return ClosestTarget
end

--[[ old get target
function GetTarget()
    local ClosestPlayer = nil
    local FarthestDistance = math.huge
    local Camera = Workspace.CurrentCamera
    if Config.TargetMode == "NPC" then
        for Index, NPC in pairs(NPCFolder:GetChildren()) do
            if NPC:FindFirstChild(Config.AimHitbox) and NPC:FindFirstChild("Vest") then
                if NPC:FindFirstChildOfClass("Humanoid") and NPC:FindFirstChildOfClass("Humanoid").Health ~= 0 then
                    local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(NPC:FindFirstChild(Config.AimHitbox).Position)
                    if OnScreen and Wallcheck(NPC:FindFirstChild(Config.AimHitbox)) then
                        local MouseDistance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if MouseDistance < FarthestDistance and MouseDistance <= Config.FieldOfView then
                            FarthestDistance = MouseDistance
                            ClosestPlayer = NPC:FindFirstChild(Config.AimHitbox)
                        end
                    end
                end
            end
        end
    elseif Config.TargetMode == "Player" then
        for Index, Player in pairs(PlayerService:GetPlayers()) do
            if Player ~= LocalPlayer and TeamCheck(Player) then
                if Player.Character and Player.Character:FindFirstChild(Config.AimHitbox) then
                    if Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChildOfClass("Humanoid").Health ~= 0 then
                        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Player.Character:FindFirstChild(Config.AimHitbox).Position)
                        if OnScreen and Wallcheck(Player.Character:FindFirstChild(Config.AimHitbox)) then
                            local MouseDistance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                            if MouseDistance < FarthestDistance and MouseDistance <= Config.FieldOfView then
                                FarthestDistance = MouseDistance
                                ClosestPlayer = Player.Character:FindFirstChild(Config.AimHitbox)
                            end
                        end
                    end
                end
            end
        end
    end
    return ClosestPlayer
end
]]

local function Require(Name)
    for Index, Instance in pairs(getnilinstances()) do
        if Instance.Name == Name then
            return require(Instance)
        end
    end
end

-- game modules hook
local ControllerClass = Require("ControllerClass")
local controllerOld
while task.wait() do
    if ControllerClass and ControllerClass.LateUpdate then
        controllerOld = ControllerClass.LateUpdate
        break
    else
        ControllerClass = Require("ControllerClass")
    end
end
if ControllerClass and controllerOld then
    ControllerClass.LateUpdate = function(...)
        local args = {...}
        if Config.Speedhack then
            args[1].Speed = Config.SpeedhackValue
        end
        return controllerOld(...)
    end
end

local CharacterCamera = Require("CharacterCamera")
local cameraOld
while task.wait() do
    if CharacterCamera and CharacterCamera.Update then
        cameraOld = CharacterCamera.Update
        break
    else
        CharacterCamera = Require("CharacterCamera")
    end
end
if CharacterCamera and cameraOld then
    CharacterCamera.Update = function(...)
        local args = {...}
        args[1]._shakes = {}
        args[1]._bob = 0
        if Config.NoRecoil then
            args[1]._recoil.Velocity = Vector3.zero
        end
        return cameraOld(...)
    end
end

local TurretCamera = Require("TurretCamera")
local turretCamOld
while task.wait() do
    if TurretCamera and TurretCamera.Update then
        turretCamOld = TurretCamera.Update
        break
    else
        TurretCamera = Require("TurretCamera")
    end
end
if TurretCamera and turretCamOld then
    TurretCamera.Update = function(...)
        local args = {...}
        if Config.NoRecoil then
            args[1]._recoil.Velocity = Vector3.zero
        end
        return turretCamOld(...)
    end
end

local FirearmInventory = Require("FirearmInventory")
local firearmDischargeOld
local firearmNewOld
while task.wait() do
    if FirearmInventory and FirearmInventory._discharge and FirearmInventory.new then
        firearmDischargeOld = FirearmInventory._discharge
        firearmNewOld = FirearmInventory.new
        break
    else
        FirearmInventory = Require("FirearmInventory")
    end
end
if FirearmInventory and firearmDischargeOld and firearmNewOld then
    FirearmInventory._discharge = function(...)
        local args = {...}
        if Config.RapidFire then
            args[1]._config.Tune.RPM = Config.RapidFireValue
        end
        if Config.InstantHit then
            args[1]._config.Tune.Velocity = 9e9
        end
        return firearmDischargeOld(...)
    end
    FirearmInventory.new = function(...)
        local args = {...}
        if Config.UnlockFiremodes then
            if not table.find(args[2].Tune.Firemodes,1) then
                table.insert(args[2].Tune.Firemodes,1)
            end
            if not table.find(args[2].Tune.Firemodes,2) then
                table.insert(args[2].Tune.Firemodes,2)
            end
            if not table.find(args[2].Tune.Firemodes,3) then
                table.insert(args[2].Tune.Firemodes,3)
            end
            args[2].Mode = 1
        end
        return firearmNewOld(...)
    end
end

local GroundMovement = Require("GroundMovement")
local groundOld
while task.wait() do
    if GroundMovement and GroundMovement.Update then
        groundOld = GroundMovement.Update
        break
    else
        GroundMovement = Require("GroundMovement")
    end
end
if GroundMovement and groundOld then
    GroundMovement.Update = function(...)
        local args = {...}
        if Config.Vehicle then
            args[1]._tune.Speed = Config.VehicleSpeed
            args[1]._tune.Accelerate = Config.VehicleAcceleration
        end
        return groundOld(...)
    end
end

local HelicopterMovement = Require("HelicopterMovement")
local heliOld
while task.wait() do
    if HelicopterMovement and HelicopterMovement.Update then
        heliOld = HelicopterMovement.Update
        break
    else
        HelicopterMovement = Require("HelicopterMovement")
    end
end
if HelicopterMovement and heliOld then
    HelicopterMovement.Update = function(...)
        local args = {...}
        if Config.Helicopter then
            args[1]._tune.Speed = Config.HelicopterSpeed
        end
        return heliOld(...)
    end
end

local AircraftMovement = Require("AircraftMovement")
local aircraftDischargeOld
while task.wait() do
    if AircraftMovement and AircraftMovement._discharge then
        aircraftDischargeOld = AircraftMovement._discharge
        break
    else
        AircraftMovement = Require("AircraftMovement")
    end
end
if AircraftMovement and aircraftDischargeOld then
    AircraftMovement._discharge = function(...)
        local args = {...}
        if Config.InstantHit then
            args[1]._tune.Velocity = 9e9
        end
        AircraftTip = args[1]._tip
        return aircraftDischargeOld(...)
    end
end

local TurretMovement = Require("TurretMovement")
local turretOld
while task.wait() do
    if TurretMovement and TurretMovement._discharge then
        turretOld = TurretMovement._discharge
        break
    else
        TurretMovement = Require("TurretMovement")
    end
end
if TurretMovement and turretOld then
    TurretMovement._discharge = function(...)
        local args = {...}
        if Config.InstantHit then
            args[1]._tune.Velocity = 9e9
        end
        GroundTip = args[1]._tip
        return turretOld(...)
    end
end

-- silent aim raycast hook
local namecall
namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local namecallmethod = getnamecallmethod()
    local args = {...}
    if namecallmethod == "Raycast" then
        local Camera = Workspace.CurrentCamera
        if Target and Config.SAMode == "Gun" and args[1] == Camera.CFrame.Position then
            args[2] = (Target.Position - Camera.CFrame.Position)
        elseif Target and Config.SAMode == "Aircraft" and AircraftTip and args[1] == AircraftTip.WorldCFrame.Position then
            args[2] = (Target.Position - AircraftTip.WorldCFrame.Position)
        elseif Target and Config.SAMode == "Turret" and GroundTip and args[1] == GroundTip.WorldCFrame.Position then
            args[2] = (Target.Position - GroundTip.WorldCFrame.Position)
        end
    end
    return namecall(self, unpack(args))
end)

-- render
local Circle = Drawing.new("Circle")
RunService.Heartbeat:Connect(function()
    Circle.Visible = Config.Circle.Visible
    if Circle.Visible then
        Circle.Transparency = Config.Circle.Transparency
        Circle.Color = Config.Circle.Color
        Circle.Thickness = Config.Circle.Thickness
        Circle.NumSides = Config.Circle.NumSides
        Circle.Radius = Config.FieldOfView
        Circle.Filled = Config.Circle.Filled
        Circle.Position = UserInputService:GetMouseLocation()
    end

    if Aimbot or Config.SilentAim or InstantSA then
        Target = GetTarget()
    else
        Target = nil
    end
    if Aimbot and Target then
        local Camera = Workspace.CurrentCamera
        local Mouse = UserInputService:GetMouseLocation()
        local TargetPos = Camera:WorldToViewportPoint(Target.Position)
        mousemoverel((TargetPos.X - Mouse.X) * Config.Sensitivity, (TargetPos.Y - Mouse.Y) * Config.Sensitivity)
    end

    if Config.EnvEnable then
        Lighting.ClockTime = Config.EnvTime
        Lighting.Brightness = Config.EnvBrightness
        Lighting.Atmosphere.Density = Config.EnvFog
    else
        Lighting.Brightness = 2
        Lighting.Atmosphere.Density = 0.25
    end
end)

for Index, NPC in pairs(NPCFolder:GetChildren()) do
    if NPC:WaitForChild("Vest",0.5) then
        ESPLibrary.Add("NPC", NPC, Config.NPCESP)
    end
end
NPCFolder.ChildAdded:Connect(function(NPC)
    if NPC:WaitForChild("Vest",0.5) then
        ESPLibrary.Add("NPC", NPC, Config.NPCESP)
    end
end)
NPCFolder.ChildRemoved:Connect(function(NPC)
    ESPLibrary.Remove(NPC)
end)

for Index, Player in pairs(PlayerService:GetPlayers()) do
    if Player ~= LocalPlayer then
        ESPLibrary.Add("Player", Player, Config.PlayerESP)
    end
end
PlayerService.PlayerAdded:Connect(function(Player)
    ESPLibrary.Add("Player", Player, Config.PlayerESP)
end)
PlayerService.PlayerRemoving:Connect(function(Player)
    if Player == LocalPlayer then SaveConfig() end
    ESPLibrary.Remove(Player)
end)
