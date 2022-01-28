local RunService = Game:GetService("RunService")
local PlayerService = Game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer

local ESPLibrary = {}
local ESPTable = {}

function PlayerManager(Player)
    local InEnemyTeam = true
    local IsAlive = true
    if LocalPlayer.Team == Player.Team then
        InEnemyTeam = false
    end
    return InEnemyTeam, Player.TeamColor.Color
end

local function CharacterManager(Character)
    local IsAlive = true
    if Character and Character:FindFirstChildOfClass("Humanoid") then
        IsAlive = Character:FindFirstChildOfClass("Humanoid").Health > 0
    end
    return IsAlive
end

local function GetDistanceFromClient(Position)
    return LocalPlayer:DistanceFromCharacter(Position)
end

local function AddDrawing(Type, Properties)
    local Drawing = Drawing.new(Type)
    for Index, Property in pairs(Properties) do
        Drawing[Index] = Property
    end
    return Drawing
end
--[[
local function CalculateBox(Model)
    if not Model then return end
    local CFrame, Size = Model:GetBoundingBox()
    local Camera = Workspace.CurrentCamera
    
    local CornerTable = {
        TopLeft = Camera:WorldToViewportPoint(Vector3.new(CFrame.X - Size.X / 2, CFrame.Y + Size.Y / 2, CFrame.Z)),
        TopRight = Camera:WorldToViewportPoint(Vector3.new(CFrame.X + Size.X / 2, CFrame.Y + Size.Y / 2, CFrame.Z)),
        BottomLeft = Camera:WorldToViewportPoint(Vector3.new(CFrame.X - Size.X / 2, CFrame.Y - Size.Y / 2, CFrame.Z)),
        BottomRight = Camera:WorldToViewportPoint(Vector3.new(CFrame.X + Size.X / 2, CFrame.Y - Size.Y / 2, CFrame.Z))
    }
    
    local WorldPosition, OnScreen = Camera:WorldToViewportPoint(CFrame.Position)
    local ScreenSize = Vector2.new((CornerTable.TopLeft - CornerTable.TopRight).Magnitude, (CornerTable.TopLeft - CornerTable.BottomLeft).Magnitude)
    local ScreenPosition = Vector2.new(WorldPosition.X - ScreenSize.X / 2, WorldPosition.Y - ScreenSize.Y / 2)
    
    return {
        WorldPosition = WorldPosition,
        ScreenPosition = ScreenPosition, 
        ScreenSize = ScreenSize,
        OnScreen = OnScreen
    }
end
]]

local function CalculateBox(Model,Position,WorldPosition)
    local Camera = Workspace.CurrentCamera
    local Size = Model:GetExtentsSize()

    local CornerTable = {
        TopLeft = Camera:WorldToViewportPoint(Vector3.new(Position.X - Size.X * 0.5, Position.Y + Size.Y * 0.5, Position.Z)),
        TopRight = Camera:WorldToViewportPoint(Vector3.new(Position.X + Size.X * 0.5, Position.Y + Size.Y * 0.5, Position.Z)),
        BottomLeft = Camera:WorldToViewportPoint(Vector3.new(Position.X - Size.X * 0.5, Position.Y - Size.Y * 0.5, Position.Z)),
        BottomRight = Camera:WorldToViewportPoint(Vector3.new(Position.X + Size.X * 0.5, Position.Y - Size.Y * 0.5, Position.Z))
    }
    local ScreenSize = Vector2.new((CornerTable.TopLeft - CornerTable.TopRight).Magnitude, (CornerTable.TopLeft - CornerTable.BottomLeft).Magnitude)
    return Vector2.new(WorldPosition.X - ScreenSize.X * 0.5, WorldPosition.Y - ScreenSize.Y * 0.5), ScreenSize
end

if game.PlaceId == 5565801610 or game.PlaceId == 5945728589 then
    function PlayerManager(Player)
        if Player.Character and Player.Character:FindFirstChild("Team") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Team") then
            if Player.Character.Team.Value ~= LocalPlayer.Character.Team.Value or Player.Character.Team.Value == "None" then
                return true, Player.Character.Torso.Color
            else
                return false, Player.Character.Torso.Color
            end
        end
        return true, Player.TeamColor.Color
    end
end

function ESPLibrary.Add(Mode, Model, Config)
    if not ESPTable[Model] then
        ESPTable[Model] = {
            Config = Config,
            Mode = Mode,
            Model = Model,
            Drawing = {
                Box = {
                    Main = AddDrawing("Square", {
                        ZIndex = 1,
                        Transparency = 1,
                        Thickness = 1,
                        Filled = false
                    }),
                    Outline = AddDrawing("Square", {
                        ZIndex = 0,
                        Transparency = 1,
                        Color = Color3.new(0,0,0),
                        Thickness = 3,
                        Filled = false
                    })
                },
                HeadCircle = AddDrawing("Circle", {
                    ZIndex = 1,
                    Transparency = 1,
                    Thickness = 1,
                    NumSides = 100,
                    Radius = 10,
                    Filled = false
                }),
                Text = AddDrawing("Text", {
                    ZIndex = 1,
                    Transparency = 1,
                    Color = Color3.new(1,1,1),
                    Size = 14,
                    Center = true,
                    Outline = true,
                    OutlineColor = Color3.new(0,0,0)
                })
            }
        }
        return ESPTable[Model]
    end
end

function ESPLibrary.Remove(Model)
    if ESPTable[Model] then
        for Index, Drawing in pairs(ESPTable[Model].Drawing) do
            if Drawing.Remove then
                Drawing:Remove()
            else
                for Index2, Drawing2 in pairs(Drawing) do
                    Drawing2:Remove()
                end
            end
        end
        ESPTable[Model] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for Index, ESP in pairs(ESPTable) do
        local WorldPosition, OnScreen, IsAlive, InEnemyTeam, TeamColor = nil, false, true, true, nil

        if ESP.Mode == "Player" then
            if ESP.Model.Character and ESP.Model.Character.PrimaryPart then
                local Camera = Workspace.CurrentCamera
                WorldPosition, OnScreen = Camera:WorldToViewportPoint(ESP.Model.Character.PrimaryPart.Position)

                if OnScreen then
                    InEnemyTeam,TeamColor = PlayerManager(ESP.Model)
                    IsAlive = CharacterManager(ESP.Model.Character)
                    if ESP.Drawing.HeadCircle.Visible and ESP.Model.Character:FindFirstChild("Head") then
                        local HeadPosition = Camera:WorldToViewportPoint(ESP.Model.Character.Head.Position)
                        ESP.Drawing.HeadCircle.Color = not ESP.Config.TeamColor and (InEnemyTeam and ESP.Config.EnemyColor or ESP.Config.AllyColor) or TeamColor
                        ESP.Drawing.HeadCircle.Radius = ESP.Config.HeadCircleRadius
                        ESP.Drawing.HeadCircle.NumSides = ESP.Config.HeadCircleNumSides
                        ESP.Drawing.HeadCircle.Filled = ESP.Config.HeadCircleFilled
                        ESP.Drawing.HeadCircle.Position = Vector2.new(HeadPosition.X,HeadPosition.Y)
                    end
                    if ESP.Drawing.Box.Main.Visible or ESP.Drawing.Text.Visible then
                        local ScreenPosition, ScreenSize = CalculateBox(ESP.Model.Character,ESP.Model.Character.PrimaryPart.CFrame.Position,WorldPosition)
                        if ESP.Drawing.Box.Main.Visible then
                            ESP.Drawing.Box.Main.Color = not ESP.Config.TeamColor and (InEnemyTeam and ESP.Config.EnemyColor or ESP.Config.AllyColor) or TeamColor
                            ESP.Drawing.Box.Main.Size = ScreenSize
                            ESP.Drawing.Box.Main.Position = ScreenPosition
                            ESP.Drawing.Box.Outline.Size = ScreenSize
                            ESP.Drawing.Box.Outline.Position = ScreenPosition
                        end
                        if ESP.Drawing.Text.Visible then
                            local Distance = GetDistanceFromClient(ESP.Model.Character.PrimaryPart.Position)
                            ESP.Drawing.Text.Size = ESP.Config.TextSize
                            ESP.Drawing.Text.Text = string.format("%s\n%d studs",ESP.Model.Name,Distance)
                            ESP.Drawing.Text.Position = Vector2.new(ScreenPosition.X + ScreenSize.X * 0.5, ScreenPosition.Y + ScreenSize.Y)
                        end
                    end
                end
            end
        else
            if ESP.Model:IsA("Model") and ESP.Model.PrimaryPart then
                local Camera = Workspace.CurrentCamera
                WorldPosition, OnScreen = Camera:WorldToViewportPoint(ESP.Model.PrimaryPart.Position)

                if OnScreen then
                    IsAlive = CharacterManager(ESP.Model)
                    if ESP.Drawing.HeadCircle.Visible and ESP.Model:FindFirstChild("Head") then
                        local HeadPosition = Camera:WorldToViewportPoint(ESP.Model.Head.Position)
                        ESP.Drawing.HeadCircle.Color = ESP.Config.EnemyColor
                        ESP.Drawing.HeadCircle.Radius = ESP.Config.HeadCircleRadius
                        ESP.Drawing.HeadCircle.NumSides = ESP.Config.HeadCircleNumSides
                        ESP.Drawing.HeadCircle.Filled = ESP.Config.HeadCircleFilled
                        ESP.Drawing.HeadCircle.Position = Vector2.new(HeadPosition.X,HeadPosition.Y)
                    end
                    if ESP.Drawing.Box.Main.Visible or ESP.Drawing.Text.Visible then
                        local ScreenPosition, ScreenSize = CalculateBox(ESP.Model,ESP.Model.PrimaryPart.CFrame.Position,WorldPosition)
                        if ESP.Drawing.Box.Main.Visible then
                            ESP.Drawing.Box.Main.Color = ESP.Config.EnemyColor
                            ESP.Drawing.Box.Main.Size = ScreenSize
                            ESP.Drawing.Box.Main.Position = ScreenPosition
                            ESP.Drawing.Box.Outline.Size = ScreenSize
                            ESP.Drawing.Box.Outline.Position = ScreenPosition
                        end
                        if ESP.Drawing.Text.Visible then
                            local Distance = GetDistanceFromClient(ESP.Model.PrimaryPart.Position)
                            ESP.Drawing.Text.Size = ESP.Config.TextSize
                            ESP.Drawing.Text.Text = string.format("%s\n%d studs",ESP.Config.Name,Distance)
                            ESP.Drawing.Text.Position = Vector2.new(ScreenPosition.X + ScreenSize.X * 0.5, ScreenPosition.Y + ScreenSize.Y)
                        end
                    end
                end
            end
        end
        ESP.Drawing.Box.Main.Visible = (OnScreen and IsAlive and not ESP.Config.IsEnemy and ESP.Config.BoxVisible) or (OnScreen and IsAlive and InEnemyTeam and ESP.Config.BoxVisible)
        ESP.Drawing.Box.Outline.Visible = ESP.Drawing.Box.Main.Visible
        ESP.Drawing.HeadCircle.Visible = (OnScreen and IsAlive and not ESP.Config.IsEnemy and ESP.Config.HeadCircleVisible) or (OnScreen and IsAlive and InEnemyTeam and ESP.Config.HeadCircleVisible)
        ESP.Drawing.Text.Visible = (OnScreen and IsAlive and not ESP.Config.IsEnemy and ESP.Config.TextVisible) or (OnScreen and IsAlive and InEnemyTeam and ESP.Config.TextVisible)
    end
end)

return ESPLibrary
