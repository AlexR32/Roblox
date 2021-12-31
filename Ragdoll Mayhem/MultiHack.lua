local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer

if not Workspace:FindFirstChild("Drops") or not Workspace:FindFirstChild("Projectiles") then
    warn("cant find required folders")
    return
end

if not getgenv().Config then
getgenv().Config = {

    -- FoV Circle
    CircleVisible = true,
    CircleTransparency = 1,
    CircleColor = Color3.fromRGB(255,128,64),
    CircleThickness = 1,
    CircleNumSides = 30,
    CircleFilled = false,
    CircleRainbow = false,

    -- ESP
    OutlineVisible = true,
    TextVisible = true,
    HealthbarVisible = false,
    BoxVisible = true,
    Color = Color3.fromRGB(255,128,64),
    Rainbow = false,

    -- Aimbot and Silent Aim
    SilentAim = false,
    Aimbot = false,
    Sensitivity = 0.1,
    FieldOfView = 100,
    AimHitbox = "Head"
}
end

local Library = loadstring(Game:GetObjects("rbxassetid://7974127463")[1].Source)()
local Window = Library({Name = "RAGDOLL UNIVERSE"}) do
	local MainTab = Window:AddTab({Name = "Main"}) do
        MainTab:AddToggle({Name = "Slient Aim",Side = "Left",Value = Config.SilentAim,Callback = function(Bool) 
            Config.SilentAim = Bool
        end})
        MainTab:AddBind({Name = "Aimbot",Side = "Left",Key = "MouseButton2",Mouse = true,Callback = function(Bool) 
            Config.Aimbot = Bool
        end})
		local AimbotSection = MainTab:AddSection({Name = "Settings",Side = "Left"}) do
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
        MainTab:AddToggle({Name = "Circle",Side = "Right",Value = Config.CircleVisible,Callback = function(Bool) 
            Config.CircleVisible = Bool
        end})
        local CircleSection = MainTab:AddSection({Name = "Settings",Side = "Right"}) do
            CircleSection:AddSlider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Config.CircleTransparency,Callback = function(Number)
                Config.CircleTransparency = Number
            end})
            CircleSection:AddSlider({Name = "Thickness",Min = 1,Max = 5,Value = Config.CircleThickness,Callback = function(Number)
                Config.CircleThickness = Number
            end})
            CircleSection:AddSlider({Name = "NumSides",Min = 3, Max = 100,Value = Config.CircleNumSides,Callback = function(Number)
                Config.CircleNumSides = Number
            end})
            CircleSection:AddToggle({Name = "Filled",Value = Config.CircleFilled,Callback = function(Bool) 
                Config.CircleFilled = Bool
            end})
            CircleSection:AddColorpicker({Name = "Color",Color = Config.CircleColor,Callback = function(Color)
                Config.CircleColor = Color
            end})
            CircleSection:AddToggle({Name = "Rainbow",Value = Config.CircleRainbow,Callback = function(Bool) 
                Config.CircleRainbow = Bool
            end})
		end
        local ESPSection = MainTab:AddSection({Name = "ESP",Side = "Left"}) do
            ESPSection:AddToggle({Name = "Box",Value = Config.BoxVisible,Callback = function(Bool) 
                Config.BoxVisible = Bool
            end})
            ESPSection:AddToggle({Name = "Text",Value = Config.TextVisible,Callback = function(Bool) 
                Config.TextVisible = Bool
            end})
            ESPSection:AddToggle({Name = "Healthbar",Value = Config.HealthbarVisible,Callback = function(Bool) 
                Config.HealthbarVisible = Bool
            end})
            ESPSection:AddToggle({Name = "Outline",Value = Config.OutlineVisible,Callback = function(Bool) 
                Config.OutlineVisible = Bool
            end})
            ESPSection:AddColorpicker({Name = "Color",Color = Config.Color,Callback = function(Color)
                Config.Color = Color
            end})
            ESPSection:AddToggle({Name = "Rainbow",Value = Config.Rainbow,Callback = function(Bool) 
                Config.Rainbow = Bool
            end})
		end
	end
    local SettingsTab = Window:AddTab({Name = "UI Settings"}) do
		SettingsTab:AddToggle({Name = "Enabled",Side = "Left",Value = Window.Enabled,Callback = function(Bool) 
            Window:Toggle(Bool)
        end}):AddBind({Key = "RightShift",Callback = function()end})
        SettingsTab:AddColorpicker({Name = "Color",Side = "Left",Color = Window.Color,Callback = function(Color)
            Window:ChangeColor(Color)
        end})
        SettingsTab:AddButton({Name = "Server Hop",Side = "Left",Callback = function()
            -- Credits to Infinite Yield for serverhop
            local x = {}
            for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
                if type(v) == "table" and v.id ~= game.JobId then
                    x[#x + 1] = v.id
                end
            end
            if #x > 0 then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
            else
                return warn("Serverhop: Couldn't find a server.")
            end
        end})
        local BackgroundSection = SettingsTab:AddSection({Name = "Background",Side = "Right"}) do
            BackgroundSection:AddDropdown({Name = "Image",Default = "Floral",
            List = {"Default","Hearts","Abstract","Hexagon","Circles","Lace With Flowers","Floral"},
            Callback = function(String)
                -- Credits to Jan for cool patterns <3
                if String == "Default" then
                    Window.Background.Image = "rbxassetid://2151741365"
                elseif String == "Hearts" then
                    Window.Background.Image = "rbxassetid://6073763717"
                elseif String == "Abstract" then
                    Window.Background.Image = "rbxassetid://6073743871"
                elseif String == "Hexagon" then
                    Window.Background.Image = "rbxassetid://6073628839"
                elseif String == "Circles" then
                    Window.Background.Image = "rbxassetid://6071579801"
                elseif String == "Lace With Flowers" then
                    Window.Background.Image = "rbxassetid://6071575925"
                elseif String == "Floral" then
                    Window.Background.Image = "rbxassetid://5553946656"
                end
            end})
            BackgroundSection:AddColorpicker({Name = "Image Color",Color = Window.Background.ImageColor3,Callback = function(Color)
                Window.Background.ImageColor3 = Color
            end})
            BackgroundSection:AddSlider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Window.Background.ImageTransparency,Callback = function(Number)
                Window.Background.ImageTransparency = Number
            end})
            BackgroundSection:AddSlider({Name = "Tile Offset",Min = 74, Max = 296,Value = Window.Background.TileSize.X.Offset,Callback = function(Number)
                Window.Background.TileSize = UDim2.new(0,Number,0,Number)
            end})
            BackgroundSection:AddSlider({Name = "Tile Scale",Min = 0, Max = 1,Precise = 2,Value = Window.Background.TileSize.X.Scale,Callback = function(Number)
                Window.Background.TileSize = UDim2.new(Number,0,Number,0)
            end})
		end
	end
end

local function GetCorners(Model)
    local CFrame, Size = Model:GetBoundingBox()
    local CornerTable = {
        Vector3.new(CFrame.X + Size.X / 2, CFrame.Y + Size.Y / 2, CFrame.Z), -- TopRight
        Vector3.new(CFrame.X - Size.X / 2, CFrame.Y + Size.Y / 2, CFrame.Z), -- TopLeft

        Vector3.new(CFrame.X - Size.X / 2, CFrame.Y - Size.Y / 2, CFrame.Z), -- BottomLeft
        Vector3.new(CFrame.X + Size.X / 2, CFrame.Y - Size.Y / 2, CFrame.Z), -- BottomRight
    }

    local xMin = Camera.ViewportSize.X
    local yMin = Camera.ViewportSize.Y
    local xMax = 0
    local yMax = 0
                            
    for _, Corner in next, CornerTable do
        local Position = Camera:WorldToViewportPoint(Corner)

        if Position.X > xMax then
            xMax = Position.X
        end

        if Position.X < xMin then
            xMin = Position.X
        end

        if Position.Y > yMax then
            yMax = Position.Y
        end

        if Position.Y < yMin then
            yMin = Position.Y
        end
    end

    return xMax - xMin,yMax - yMin,xMin,yMin,xMax,yMax
end

local function CreateESP(Model)
    local Text = Drawing.new("Text")
    local HealthbarOutline = Drawing.new("Square")
    local Healthbar = Drawing.new("Square")
    local BoxOutline = Drawing.new("Square")
    local Box = Drawing.new("Square")

    local Render = RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Torso") then
            if Model and Model:FindFirstChild("Torso") then
                if Model:FindFirstChildOfClass("Humanoid") and Model:FindFirstChildOfClass("Humanoid").Health ~= 0 then
                    Camera = Workspace.CurrentCamera
                    local Vector, OnScreen = Camera:WorldToViewportPoint(Model.Torso.Position)
                    if OnScreen then
                        local xSize,ySize,xMin,yMin,xMax,yMax = GetCorners(Model)

                        Text.Visible = Config.TextVisible
                        Text.Transparency = 1
                        Text.Color = Color3.fromRGB(255,255,255)
                        Text.Text = Model.Name .. "\n" .. math.round((LocalPlayer.Character.Torso.Position - Model.Torso.Position).Magnitude) .. " studs"
                        Text.Size = 20
                        Text.Center = true
                        Text.Outline = Config.OutlineVisible
                        Text.OutlineColor = Color3.fromRGB(0,0,0)
                        Text.Position = Vector2.new(xMax - xSize/2, yMax)

                        HealthbarOutline.Visible = Config.HealthbarVisible and Config.OutlineVisible
                        HealthbarOutline.Transparency = 1
                        HealthbarOutline.Color = Color3.fromRGB(0,0,0)
                        HealthbarOutline.Thickness = 1
                        HealthbarOutline.Filled = true

                        HealthbarOutline.Size = Vector2.new(4,-ySize-2)
                        HealthbarOutline.Position = Vector2.new(xMin-8,yMax+1)

                        Healthbar.Visible = Config.HealthbarVisible
                        Healthbar.Transparency = 1
                        Healthbar.Color = Color3.fromRGB(255,0,0):Lerp(Color3.fromRGB(0,255,0), Model.Humanoid.Health/Model.Humanoid.MaxHealth)
                        Healthbar.Thickness = 1
                        Healthbar.Filled = true

                        Healthbar.Size = Vector2.new(2,0):Lerp(Vector2.new(2,-ySize),Model.Humanoid.Health/Model.Humanoid.MaxHealth)
                        Healthbar.Position = Vector2.new(xMin-7,yMax)

                        BoxOutline.Visible = Config.BoxVisible and Config.OutlineVisible
                        BoxOutline.Transparency = 1
                        BoxOutline.Color = Color3.fromRGB(0,0,0)
                        BoxOutline.Thickness = 3
                        BoxOutline.Filled = false

                        BoxOutline.Size = Vector2.new(xSize,ySize)
                        BoxOutline.Position = Vector2.new(xMin,yMin)

                        Box.Visible = Config.BoxVisible
                        Box.Transparency = 1
                        Box.Color = Config.Color
                        Box.Thickness = 1
                        Box.Filled = false

                        Box.Size = Vector2.new(xSize, ySize)
                        Box.Position = Vector2.new(xMin, yMin)
                    else
                        Text.Visible = false
                        HealthbarOutline.Visible = false
                        Healthbar.Visible = false
                        BoxOutline.Visible = false
                        Box.Visible = false
                    end
                else
                    Text.Visible = false
                    HealthbarOutline.Visible = false
                    Healthbar.Visible = false
                    BoxOutline.Visible = false
                    Box.Visible = false
                end
            else
                Text.Visible = false
                HealthbarOutline.Visible = false
                Healthbar.Visible = false
                BoxOutline.Visible = false
                Box.Visible = false
            end
        else
            Text.Visible = false
            HealthbarOutline.Visible = false
            Healthbar.Visible = false
            BoxOutline.Visible = false
            Box.Visible = false
        end
    end)

    Model.AncestryChanged:Connect(function(Child, Parent)
        if not Parent then
            Render:Disconnect()
            Text:Remove()
            HealthbarOutline:Remove()
            Healthbar:Remove()
            BoxOutline:Remove()
            Box:Remove()
        end
    end)
end

local function TeamCheck(Player)
    if Player.Character and Player.Character:FindFirstChild("Team") then
        if Player.Character.Team.Value ~= LocalPlayer.Character.Team.Value or Player.Character.Team.Value == "None" then
            return true
        else
            return false
        end
    end
    return true
end

local function GetTarget()
    local ClosestPlayer = nil
    local FarthestDistance = math.huge
    local Camera = Workspace.CurrentCamera
    for _, Player in pairs(PlayerService:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild(Config.AimHitbox) and TeamCheck(Player) then
            if Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChildOfClass("Humanoid").Health ~= 0 then
                local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Player.Character:FindFirstChild(Config.AimHitbox).Position)
                if OnScreen then
                    local MouseDistance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if MouseDistance < FarthestDistance and MouseDistance <= Config.FieldOfView then
                        FarthestDistance = MouseDistance
                        ClosestPlayer = Player.Character:FindFirstChild(Config.AimHitbox)
                    end
                end
            end
        end
    end
    return ClosestPlayer
end

local function GetTargetDummyDebug()
    local ClosestPlayer = nil
    local FarthestDistance = math.huge
    local Camera = Workspace.CurrentCamera
    for _, Player in pairs(Workspace.LiveRagdolls:GetChildren()) do
        if Player.Name ~= LocalPlayer.Name and Player:FindFirstChild(Config.AimHitbox) then
            if Player:FindFirstChildOfClass("Humanoid") and Player:FindFirstChildOfClass("Humanoid").Health ~= 0 then
                local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Player:FindFirstChild(Config.AimHitbox).Position)
                if OnScreen then
                    local MouseDistance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if MouseDistance < FarthestDistance and MouseDistance <= Config.FieldOfView then
                        FarthestDistance = MouseDistance
                        ClosestPlayer = Player:FindFirstChild(Config.AimHitbox)
                    end
                end
            end
        end
    end
    return ClosestPlayer
end

local function returnHit(hit, args)
    local Camera = Workspace.CurrentCamera
    local CameraPosition = Camera.CFrame.Position
    if table.find(args[2],LocalPlayer.Character,1) and table.find(args[2],Workspace.Drops,3) and table.find(args[2],Workspace.Drops,4) and table.find(args[2],Workspace.Projectiles,5) then
        args[1] = Ray.new(CameraPosition, hit.Position - CameraPosition)
        return
    end
end

local namecall
namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local namecallmethod = getnamecallmethod()
    if namecallmethod == "FindPartOnRayWithIgnoreList" then
        if hit then
            returnHit(hit, args)
        end
    end
    return namecall(self, unpack(args))
end)

local Circle = Drawing.new("Circle")
RunService.RenderStepped:Connect(function()
    Circle.Visible = Config.CircleVisible
    Circle.Transparency = Config.CircleTransparency
    Circle.Color = Config.CircleColor

    Circle.Thickness = Config.CircleThickness
    Circle.NumSides = Config.CircleNumSides
    Circle.Radius = Config.FieldOfView
    Circle.Filled = Config.CircleFilled
    Circle.Position = UserInputService:GetMouseLocation()

    if Config.SilentAim then
        hit = GetTarget()
    else
        hit = nil
    end

    if Config.Aimbot then
        --if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local Target = GetTarget()
            if Target then
                local Camera = Workspace.CurrentCamera
                local Mouse = UserInputService:GetMouseLocation()
                local TargetPos = Camera:WorldToViewportPoint(Target.Position)
                mousemoverel((TargetPos.X - Mouse.X) * Config.Sensitivity, (TargetPos.Y - Mouse.Y) * Config.Sensitivity)
            end
        --end
    end

    if Config.Rainbow then
        local Hue, Saturation, Value = Config.Color:ToHSV()
        if Hue == 1 then
            Hue = 0
        end
        Config.Color = Color3.fromHSV(Hue + 0.001, 1, 1)
    end
    if Config.CircleRainbow then
        local Hue, Saturation, Value = Config.CircleColor:ToHSV()
        if Hue == 1 then
            Hue = 0
        end
        Config.CircleColor = Color3.fromHSV(Hue + 0.001, 1, 1)
    end
end)

for Index, Player in pairs(PlayerService:GetPlayers()) do
    if Player == LocalPlayer then continue end
    CreateESP(Player.Character)
    Player.CharacterAdded:Connect(function(Character)
        CreateESP(Character)
    end)
end

PlayerService.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        CreateESP(Character)
    end)
end)
