-- script execute checks
repeat task.wait() until game.IsLoaded
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/TypeWriter.lua"))()
if getgenv().MultihackExecuted then NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> script already executed",15,0) return end
getgenv().MultihackExecuted = true

-- dependencies
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer
local Camera = Workspace.CurrentCamera

-- variables
local Target = nil
local Aimbot = false

-- various checks and QOT
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
        QueueOnTeleport(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/Ragdoll%20Mayhem/MultiHack.lua"))
    end
end)

if not Workspace:FindFirstChild("Drops") or not Workspace:FindFirstChild("Projectiles") then
    NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> cant find required folders, making finding loop...",15,0)
    while task.wait() do
        if Workspace:FindFirstChild("Drops") and Workspace:FindFirstChild("Projectiles") then
            NotifyLib.TypeWrite("<font color=\"rgb(255,128,64)\"><b>warn</b></font><b>:</b> required folders founded",15,0)
            break
        end
    end
end

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/ESPLibrary.lua"))()
local ConfigSystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/ConfigSystem.lua"))()

-- config system
local function SaveConfig()
    if isfile("Alex's Scripts/RU_SilentAim.json") then
        ConfigSystem.WriteJSON(Config,"Alex's Scripts/RU_SilentAim.json")
    else
        makefolder("Alex's Scripts")
        ConfigSystem.WriteJSON(Config,"Alex's Scripts/RU_SilentAim.json")
    end
end
local function LoadConfig()
    if isfile("Alex's Scripts/RU_SilentAim.json") then
        getgenv().Config = ConfigSystem.ReadJSON("Alex's Scripts/RU_SilentAim.json",Config)
    else
        makefolder("Alex's Scripts")
        ConfigSystem.WriteJSON(Config,"Alex's Scripts/RU_SilentAim.json")
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

    Circle = {
        Visible = true,
        Transparency = 1,
        Color = Color3.fromRGB(255,128,64),
        Thickness = 1,
        NumSides = 100,
        Filled = false
    },

    Binds = {
        Aimbot = "NONE",
        SilentAim = "NONE"
    },

    SilentAim = false,
    WallCheck = false,
    Sensitivity = 0.5,
    FieldOfView = 100,
    AimHitbox = "Head"
}
LoadConfig()

-- ui library
local Library = loadstring(game:GetObjects("rbxassetid://7974127463")[1].Source)()
local Window = Library({Name = "RAGDOLL UNIVERSE Multihack",Enabled = Config.UI.Enabled,Color = Config.UI.Color,Position = UDim2.new(0.2,-248,0.5,-248)}) do
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
            AimbotSection:AddToggle({Name = "WallCheck",Value = Config.WallCheck,Callback = function(Bool)
                Config.WallCheck = Bool
            end})
            AimbotSection:AddSlider({Name = "Sensitivity",Min = 0,Max = 1,Precise = 2,Value = Config.Sensitivity,Callback = function(Number)
                Config.Sensitivity = Number
            end})
            AimbotSection:AddSlider({Name = "Field Of View",Min = 0,Max = 500,Value = Config.FieldOfView,Callback = function(Number)
                Config.FieldOfView = Number
            end})
            AimbotSection:AddDropdown({Name = "Hitbox",Default = Config.AimHitbox,List = {"Head", "Torso"},Callback = function(String)
                Config.AimHitbox = String
            end})
        end
        local PlayerESPSection = MainTab:AddSection({Name = "Player ESP",Side = "Left"}) do
            PlayerESPSection:AddColorpicker({Name = "Ally Color",Color = Config.PlayerESP.AllyColor,Callback = function(Color)
                Config.PlayerESP.AllyColor = Color
            end})
            PlayerESPSection:AddColorpicker({Name = "Enemy Color",Color = Config.PlayerESP.EnemyColor,Callback = function(Color)
                Config.PlayerESP.EnemyColor = Color
            end})
            PlayerESPSection:AddToggle({Name = "Use Body Color",Value = Config.PlayerESP.TeamColor,Callback = function(Bool)
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
            CircleSection:AddToggle({Name = "Enable",Value = Config.Circle.Visible,Callback = function(Bool)
                Config.Circle.Visible = Bool
            end})
            CircleSection:AddToggle({Name = "Filled",Value = Config.Circle.Filled,Callback = function(Bool)
                Config.Circle.Filled = Bool
            end})
            CircleSection:AddColorpicker({Name = "Color",Color = Config.Circle.Color,Callback = function(Color)
                Config.Circle.Color = Color
            end})
            CircleSection:AddSlider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Config.Circle.Transparency,Callback = function(Number)
                Config.Circle.Transparency = Number
            end})
            CircleSection:AddSlider({Name = "Thickness",Min = 1,Max = 10,Value = Config.Circle.Thickness,Callback = function(Number)
                Config.Circle.Thickness = Number
            end})
            CircleSection:AddSlider({Name = "NumSides",Min = 3,Max = 100,Value = Config.Circle.NumSides,Callback = function(Number)
                Config.Circle.NumSides = Number
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
            CreditsSection:AddLabel({Text = "❤️ ❤️ ❤️ ❤️"})
        end
    end
end

local function TeamCheck(Player)
    if Player.Character and Player.Character:FindFirstChild("Team") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Team") then
        if Player.Character.Team.Value ~= LocalPlayer.Character.Team.Value or Player.Character.Team.Value == "None" then
            return true
        else
            return false
        end
    end
    return true
end

local function WallCheck(Target)
    if Config.WallCheck then
        local Camera = Workspace.CurrentCamera
        local RaycastParameters = RaycastParams.new()
        RaycastParameters.FilterType = Enum.RaycastFilterType.Blacklist
        RaycastParameters.FilterDescendantsInstances = {LocalPlayer.Character,Target}
        RaycastParameters.IgnoreWater = true
        
        if Workspace:Raycast(Camera.CFrame.Position, Target.Position - Camera.CFrame.Position, RaycastParameters) then
            return false
        end
    end
    return true
end

local function GetTarget()
    local Camera = Workspace.CurrentCamera
    local FieldOfView = Config.FieldOfView
    local ClosestTarget = nil

    for Index, Target in pairs(PlayerService:GetPlayers()) do
        local Character = Target.Character
        local Hitbox = (Character and Character:FindFirstChild(Config.AimHitbox)) or (Character and (Character:IsA("Model") and Character.PrimaryPart))
        local Health = Character and (Character:FindFirstChildOfClass("Humanoid") and Character:FindFirstChildOfClass("Humanoid").Health > 0)
        if Target ~= LocalPlayer and Hitbox and Health and TeamCheck(Target) then
            local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
            local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
            if OnScreen and WallCheck(Hitbox) and FieldOfView > Magnitude then
                FieldOfView = Magnitude
                ClosestTarget = Hitbox
            end
        end
    end

    return ClosestTarget
end

-- silent aim hook
local namecall
namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local namecallmethod = getnamecallmethod()
    local args = {...}
    if namecallmethod == "FindPartOnRayWithIgnoreList" then
        if Target and Config.SilentAim then
            local Camera = Workspace.CurrentCamera
            if table.find(args[2],LocalPlayer.Character,1) and table.find(args[2],Workspace.Drops,3) and table.find(args[2],Workspace.Drops,4) and table.find(args[2],Workspace.Projectiles,5) then
                args[1] = Ray.new(Camera.CFrame.Position, Target.Position - Camera.CFrame.Position)
            end
        end
    end
    return namecall(self, unpack(args))
end)

-- circle and aim assist update loop
local Circle = Drawing.new("Circle")
RunService.RenderStepped:Connect(function()
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

    if Aimbot or Config.SilentAim then
        Target = GetTarget()
    else
        Target = nil
    end

    if Aimbot and Target then
        local Camera = Workspace.CurrentCamera
        local Mouse = UserInputService:GetMouseLocation()
        local TargetOnScreen = Camera:WorldToViewportPoint(Target.Position)
        mousemoverel((TargetOnScreen.X - Mouse.X) * Config.Sensitivity, (TargetOnScreen.Y - Mouse.Y) * Config.Sensitivity)
    end
end)

-- esp
for Index, Player in pairs(PlayerService:GetPlayers()) do
    if Player == LocalPlayer then continue end
    ESPLibrary.Add("Player", Player, Config.PlayerESP)
end
PlayerService.PlayerAdded:Connect(function(Player)
    ESPLibrary.Add("Player", Player, Config.PlayerESP)
end)
PlayerService.PlayerRemoving:Connect(function(Player)
    if Player == LocalPlayer then SaveConfig() end
    ESPLibrary.Remove(Player)
end)
