local RunService = Game:GetService("RunService")
local PlayerService = Game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer

local ESPLibrary = {}
local ESPTable = {}

local function GetPlayerFromCharacter(Character)
    return PlayerService[Character.Name]
end
local function GetCharacterFromPlayer(Player)
    if Player.Character then
        return Player.Character
    end
    return Player
end

local function GetTeamColorFromCharacter(Character)
    local Player = GetPlayerFromCharacter(Character)
    return Player.TeamColor.Color
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
        if not ESP.Model then continue end
        local WorldPosition, OnScreen = nil, false
        if ESP.Mode == "Player" then
            if ESP.Model.Character and ESP.Model.Character.PrimaryPart then
                local Camera = Workspace.CurrentCamera
                WorldPosition, OnScreen = Camera:WorldToViewportPoint(ESP.Model.Character.PrimaryPart.Position)
                if OnScreen then
                    local Distance = GetDistanceFromClient(ESP.Model.Character.PrimaryPart.Position)
                    local Box = CalculateBox(ESP.Model.Character)

                    if ESP.Config.TeamColor then
                        ESP.Drawing.Box.Main.Color = GetTeamColorFromCharacter(ESP.Model)
                    else
                        ESP.Drawing.Box.Main.Color = ESP.Config.Color
                    end

                    ESP.Drawing.Box.Main.Size = Box.ScreenSize
                    ESP.Drawing.Box.Main.Position = Box.ScreenPosition
                    ESP.Drawing.Box.Outline.Size = Box.ScreenSize
                    ESP.Drawing.Box.Outline.Position = Box.ScreenPosition

                    ESP.Drawing.Text.Text = string.format("%s\n%d studs",ESP.Model.Name,Distance)
                    ESP.Drawing.Text.Position = Vector2.new(Box.ScreenPosition.X + Box.ScreenSize.X/2, Box.ScreenPosition.Y + Box.ScreenSize.Y)
                end
            end
        else
            if ESP.Model:IsA("Model") and ESP.Model.PrimaryPart then
                local Camera = Workspace.CurrentCamera
                WorldPosition, OnScreen = Camera:WorldToViewportPoint(ESP.Model.PrimaryPart.Position)
                if OnScreen then
                    local Distance = GetDistanceFromClient(ESP.Model.PrimaryPart.Position)
                    local Box = CalculateBox(ESP.Model)

                    ESP.Drawing.Box.Main.Color = ESP.Config.Color
                    ESP.Drawing.Box.Main.Size = Box.ScreenSize
                    ESP.Drawing.Box.Main.Position = Box.ScreenPosition
                    ESP.Drawing.Box.Outline.Size = Box.ScreenSize
                    ESP.Drawing.Box.Outline.Position = Box.ScreenPosition

                    ESP.Drawing.Text.Text = string.format("%s\n%d studs",ESP.Config.Name,Distance)
                    ESP.Drawing.Text.Position = Vector2.new(Box.ScreenPosition.X + Box.ScreenSize.X/2, Box.ScreenPosition.Y + Box.ScreenSize.Y)
                end
            end
        end
        ESP.Drawing.Box.Main.Visible = (OnScreen and ESP.Config.BoxVisible) or false
        ESP.Drawing.Box.Outline.Visible = ESP.Drawing.Box.Main.Visible
        ESP.Drawing.Text.Visible = (OnScreen and ESP.Config.TextVisible) or false
    end
end)

return ESPLibrary
