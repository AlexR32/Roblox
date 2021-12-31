local Workspace = game:GetService("Workspace")
local PlayerService = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = PlayerService.LocalPlayer

game.StarterGui:SetCore("SendNotification", {
    Title = "TPR:R Hax";
    Text = "Welcome " .. Player.Name .. "!";
    Duration = 10
})

local PartTable = {
    "Head",
    "Torso",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Left Right"
}

function RandomColor3()
	return Color3.new(Random.new():NextNumber(0,1),Random.new():NextNumber(0,1),Random.new():NextNumber(0,1))
end

if not getgenv().Config then
    getgenv().Config = {
        PrimaryColor = Color3.fromRGB(50, 50, 100),
        SecondaryColor = Color3.fromRGB(25, 25, 50),
        AccentColor = Color3.fromRGB(15, 15, 25),
        TextColor =  Color3.new(1,1,1),
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 18,
        HeaderWidth = 250,
        HeaderHeight = 35,
        EntryMargin = 1,
        AnimationDuration = 0.5,
        AnimationEasingStyle = Enum.EasingStyle.Linear,
        DefaultEntryHeight = 45,

        SoundId = 142376088,
        Volume = 0.5,
        Type = "Looping",
        Pitch = 1,

        RC = false,
        AF = false
    }
end

local DropLibCore = loadstring(game:HttpGet("https://gitlab.com/0x45.xyz/droplib/-/raw/master/drop-minified.lua"))()
local DropLib = DropLibCore:Init(getgenv().Config, CoreGui)

local Main = DropLib:CreateCategory("Main")
local Sound = Main:CreateSection("Sound")
local Bio = Main:CreateSection("Bio")
local Misc = Main:CreateSection("Misc")

local Achievement = DropLib:CreateCategory("Achievements")
local Lobby = Achievement:CreateSection("Lobby")
local Glitchworld = Achievement:CreateSection("Glitchworld")
local FNAF = Achievement:CreateSection("FNAF")
local FNAF2 = Achievement:CreateSection("FNAF 2")
local FNAF3 = Achievement:CreateSection("FNAF 3")
local FNAF4 = Achievement:CreateSection("FNAF 4")
local FNAFUCN = Achievement:CreateSection("FNAF UCN")

local Credit = DropLib:CreateCategory("Credits")
local LibCreator = Credit:CreateSection("DropLib Creator")
local ScriptCreator = Credit:CreateSection("Script Creator")

local LibMenu = DropLib:CreateCategory("DropLib")
local LibConfig = LibMenu:CreateSection("Config")

Sound:CreateTextBox("SoundId", function(SoundId)
    getgenv().Config.SoundId = SoundId
end, nil, true, "142376088")

Sound:CreateSlider("Volume", function(Volume)
    getgenv().Config.Volume = Volume
end, 0, 10, 0.5, true, 0.5)

Sound:CreateSlider("Pitch", function(Pitch)
    getgenv().Config.Pitch = Pitch
end, 0, 20, 0.25, true, 1)

Sound:CreateSelector("Type", function(Type)
    getgenv().Config.Type = Type
end, function(GetType)
    return {"PlayOnce", "Looping"}
end, "Looping")

Sound:CreateButton("Play Sound", function()
    if getgenv().Config.SoundId == nil then
        getgenv().Config.SoundId = 142376088
        print("TPRR Hax | SoundId Set To Default")
    end
    if getgenv().Config.Volume == nil then
        getgenv().Config.Volume = 0.5
        print("TPRR Hax | Volume Set To Default")
    end
    if getgenv().Config.Type == nil then
        getgenv().Config.Type = "Looping"
        print("TPRR Hax | Type Set To Default")
    end
    if getgenv().Config.Pitch == nil then
        getgenv().Config.Pitch = 1
        print("TPRR Hax | Pitch Set To Default")
    end
    ReplicatedStorage.Events.AnimatronicSound:FireServer("AlexR32 Was Here", getgenv().Config.SoundId, getgenv().Config.Volume, getgenv().Config.Type, getgenv().Config.Pitch)
    print("TPRR Hax | Sound Playing | SoundId: " .. getgenv().Config.SoundId, "Volume: " .. getgenv().Config.Volume, "Pitch: " .. getgenv().Config.Pitch, "Type: " .. getgenv().Config.Type)
end)

Sound:CreateButton("Stop Sound", function()
    ReplicatedStorage.Events.AnimatronicSoundLoopStop:FireServer("AlexR32 Was Here")
    print("TPRR Hax | Sound Stopped")
end)

if game.PlaceId ~= 373513488 then
    Bio:CreateSwitch("Toggle Name", function(ToggleName)
        ReplicatedStorage.Events.ToggleName:FireServer(ToggleName)
    end, true)

    Bio:CreateTextBox("Change Name", function(Name)
        ReplicatedStorage.Events.NameChange:FireServer(Name)
        print("TPRR Hax | Name: " .. Name)
    end, nil, true, nil)

    Bio:CreateTextBox("Change Image", function(DecalId)
        ReplicatedStorage.Events.ImageChange:FireServer(DecalId)
        print("TPRR Hax | Decal: " .. DecalId)
    end, nil, true, nil)

    Bio:CreateTextBox("Change Description", function(Description)
        ReplicatedStorage.Events.DescChange:FireServer(Description)
        print("TPRR Hax | Description: " .. Description)
    end, nil, true, nil)

    Misc:CreateSwitch("Rainbow Character", function(RC)
        getgenv().Config.RC = RC
        while getgenv().Config.RC do
            wait(0.25)
            for Index,Part in pairs(PartTable) do
                Workspace.BodyColorChanger:FireServer(Part,RandomColor3())
            end
        end
    end)

    Misc:CreateSwitch("Tape AutoFarm", function(AF)
        getgenv().Config.AF = AF
        while getgenv().Config.AF do
            wait(0.5)
            for Index,Part in pairs(Workspace:GetChildren()) do
                if Part:IsA("Part") and Part.Name == "PotOGold" then
                    local PlayerRootPart = Player.Character.HumanoidRootPart
                    Part.CFrame = PlayerRootPart.CFrame
                elseif Part:IsA("Part") and Part.Name == "Egg" then
                    local PlayerRootPart = Player.Character.HumanoidRootPart
                    Part.CFrame = PlayerRootPart.CFrame
                elseif Part:IsA("Part") and Part.Name == "Gift" then
                    local PlayerRootPart = Player.Character.HumanoidRootPart
                    Part.CFrame = PlayerRootPart.CFrame
                elseif Part:IsA("Part") and Part.Name == "Tape" then
                    local PlayerRootPart = Player.Character.HumanoidRootPart
                    Part.CFrame = PlayerRootPart.CFrame
                end
            end
        end
    end)
elseif game.PlaceId == 373513488 then
    Bio:CreateTextLabel("This Section Does Not Work\nIn The Lobby")
    Misc:CreateTextLabel("This Section Does Not Work\nIn The Lobby")
end

if game.PlaceId == 373513488 then
    Lobby:CreateButton("Unlock Hitbox Badges", function()
        local Character = Player.Character
        local HumanoidRootPart = Character.HumanoidRootPart

        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.TopFreddy.Part.CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.GlitchworldLobby.Part.CFrame
        wait(0.5)
        Character:BreakJoints()
    end)
elseif game.PlaceId ~= 373513488 then
    Lobby:CreateTextLabel("This Section Only For Lobby")
end
if game.PlaceId == 1674513925 then
    Glitchworld:CreateButton("Unlock \"*Heya\" Badge", function()
        Workspace.SongHandler:FireServer("Megalovania")
    end)
elseif game.PlaceId ~= 1674513925 then
    Glitchworld:CreateTextLabel("This Section Only For Glitchworld")
end
if game.PlaceId == 599951915 then
    FNAF:CreateButton("Unlock Hitbox Badges", function()
        local Character = Player.Character
        local HumanoidRootPart = Character.HumanoidRootPart

        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.SecretBathroom:FindFirstChild("Part").CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.CrimeScene.Part.CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.GlitchworldFnaf1.Part.CFrame
        wait(0.5)
        Character:BreakJoints()
    end)

    FNAF:CreateButton("Unlock \"Deja Vu?\" Badge", function()
        Workspace.SpawnCars:FireServer(true)
    end)

    FNAF:CreateButton("Unlock \"Frogger\" Badge", function()
        ReplicatedStorage.Spawn:InvokeServer("Happy Frog")

        for _,Car in pairs(Workspace.CarSpawn.Part:GetChildren()) do
            if Car:IsA("MeshPart") and Car.Name == "Car" then
                local PlayerRootPart = Player.Character.HumanoidRootPart
                PlayerRootPart.CFrame = Car.CFrame
            end
        end
    end)
    FNAF:CreateTextLabel("You Need Happy Frog For This\nAchievement")
elseif game.PlaceId ~= 599951915 then
    FNAF:CreateTextLabel("This Section Only For FNAF")
end

if game.PlaceId == 599952427 then
    FNAF2:CreateButton("Unlock Hitbox Badges", function()
        local Character = Player.Character
        local HumanoidRootPart = Character.HumanoidRootPart

        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.ChihiroFreddy.Part.CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.VentRepair.Part.CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.GlitchworldFnaf2.Part.CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.Crusher.Part.CFrame
        wait(0.5)
        Character:BreakJoints()
    end)
elseif game.PlaceId ~= 599952427 then
    FNAF2:CreateTextLabel("This Section Only For FNAF 2")
end

if game.PlaceId == 2588849144 then
    FNAF3:CreateButton("Unlock Hitbox Badges", function()
        local Character = Player.Character
        local HumanoidRootPart = Character.HumanoidRootPart

        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.GlitchworldFnaf3.Part.CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.Clocktower.Part.CFrame
        wait(0.5)
        Character:BreakJoints()
    end)
elseif game.PlaceId ~= 2588849144 then
    FNAF3:CreateTextLabel("This Section Only For FNAF 3")
end

if game.PlaceId == 2588857580 then
    FNAF4:CreateButton("Unlock Hitbox Badges", function()
        local Character = Player.Character
        local HumanoidRootPart = Character.HumanoidRootPart

        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.Sewers:FindFirstChild("Part").CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.CircusTentTop.Part.CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.GlitchworldFnaf4.Part.CFrame
        wait(0.5)
        Character:BreakJoints()
    end)
elseif game.PlaceId ~= 2588857580 then
    FNAF4:CreateTextLabel("This Section Only For FNAF 4")
end

if game.PlaceId == 4691657826 then
    FNAFUCN:CreateButton("Unlock Hitbox Badges", function()
        local Character = Player.Character
        local HumanoidRootPart = Character.HumanoidRootPart

        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.UCNLava.Part.CFrame
        wait(1)
        HumanoidRootPart.CFrame = Workspace.BadgeHitboxes.GlitchworldUCN.Part.CFrame
        wait(0.5)
        Character:BreakJoints()
    end)
elseif game.PlaceId ~= 4691657826 then
    FNAFUCN:CreateTextLabel("This Section Only For FNAF UCN")
end

LibCreator:CreateTextLabel("cheb45 @ v3rmillion.net")
LibCreator:CreateTextLabel("cheb#5214 @ discord.com")

ScriptCreator:CreateTextLabel("Alex332Rus @ v3rmillion.net")
ScriptCreator:CreateTextLabel("AlexR32#6862 @ discord.com")

LibConfig:CreateColorPicker("Primary Color", function(Color)
    getgenv().Config.PrimaryColor = Color
end, true, getgenv().Config.PrimaryColor)

LibConfig:CreateColorPicker("Secondary Color", function(Color)
    getgenv().Config.SecondaryColor = Color
end, true, getgenv().Config.SecondaryColor)

LibConfig:CreateColorPicker("Accent Color", function(Color)
    getgenv().Config.AccentColor = Color
end, true, getgenv().Config.AccentColor)

LibConfig:CreateColorPicker("Text Color", function(Color)
    getgenv().Config.TextColor = Color
end, true, getgenv().Config.TextColor)

LibConfig:CreateSelector("Text Font", function(Font)
    getgenv().Config.Font = Enum.Font[Font]
end, function(GetFont)
    return {"Legacy","Arial","ArialBold","SourceSans","SourceSansBold","SourceSansSemibold","SourceSansLight","SourceSansItalic","Bodoni","Garamond","Cartoon","Code","Highway","SciFi","Arcade","Fantasy","Antique","Gotham","GothamSemibold","GothamBold","GothamBlack"}
end, string.sub(tostring(getgenv().Config.Font),11))

LibConfig:CreateSlider("Text Size", function(Size)
    getgenv().Config.TextSize = Size
end, 0, 100, 1, true, getgenv().Config.TextSize)

LibConfig:CreateSlider("Header Width", function(Size)
    getgenv().Config.HeaderWidth = Size
end, 0, 500, 1, true, getgenv().Config.HeaderWidth)

LibConfig:CreateSlider("Header Height", function(Size)
    getgenv().Config.HeaderHeight = Size
end, 0, 100, 1, true, getgenv().Config.HeaderHeight)

LibConfig:CreateSlider("Entry Margin", function(Size)
    getgenv().Config.EntryMargin = Size
end, 0, 100, 1, true, getgenv().Config.EntryMargin)

LibConfig:CreateSlider("Animation Duration", function(Time)
    getgenv().Config.AnimationDuration = Time
end, 0, 2, 0.1, true, getgenv().Config.AnimationDuration)

LibConfig:CreateSelector("Animation Easing Style", function(EasingStyle)
    getgenv().Config.AnimationEasingStyle = Enum.EasingStyle[EasingStyle]
end, function(GetEasingStyle)
    return {"Linear", "Sine","Quad","Quart","Quint"}
end, string.sub(tostring(getgenv().Config.AnimationEasingStyle),18))

--[[
LibConfig:CreateSlider("Entry Height", function(Size)
    getgenv().Config.DefaultEntryHeight = Size
end, 0, 100, 1, true, getgenv().Config.DefaultEntryHeight)
]]

LibConfig:CreateButton("Update Config", function()
    DropLib:LoadConfig(getgenv().Config)
    DropLib:RecursiveUpdateGui()
end)

LibMenu:CreateButton("Destroy", function()
    DropLib:CleanUp()
end)

-- https://gitlab.com/0x45.xyz/droplib
--loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/TPRRHax.lua"))()
