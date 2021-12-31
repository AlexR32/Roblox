local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if not getgenv().CursorConfig then
    getgenv().CursorConfig = {
        Color = Color3.fromRGB(255,255,255),
        OutlineColor = Color3.fromRGB(0,0,0),
        CrosshairColor = Color3.fromRGB(255,64,64),
        CrosshairSize = 4,
        CrosshairGap = 2,
        CrosshairThickness = 1.5,
        CrosshairEnabled = true,

        Transparency = 1,
        OutlineTransparency = 1,
        CrosshairTransparency = 1,

        Rainbow = false,
        OutlineRainbow = false,

        DeleteCursor = false
    }
end

local CursorOutline = Drawing.new("Triangle")
CursorOutline.Visible = true
CursorOutline.Transparency = CursorConfig.OutlineTransparency
CursorOutline.Color = CursorConfig.OutlineColor
CursorOutline.Thickness = 1
CursorOutline.Filled = true

local Cursor = Drawing.new("Triangle")
Cursor.Visible = true
Cursor.Transparency = CursorConfig.Transparency
Cursor.Color = CursorConfig.Color
Cursor.Thickness = 1
Cursor.Filled = true

local CrosshairL = Drawing.new("Line")
CrosshairL.Visible = true
CrosshairL.Transparency = CursorConfig.CrosshairTransparency
CrosshairL.Color = CursorConfig.CrosshairColor
CrosshairL.Thickness = CursorConfig.CrosshairThickness

local CrosshairR = Drawing.new("Line")
CrosshairR.Visible = true
CrosshairR.Transparency = CursorConfig.CrosshairTransparency
CrosshairR.Color = CursorConfig.CrosshairColor
CrosshairR.Thickness = CursorConfig.CrosshairThickness

local CrosshairT = Drawing.new("Line")
CrosshairT.Visible = true
CrosshairT.Transparency = CursorConfig.CrosshairTransparency
CrosshairT.Color = CursorConfig.CrosshairColor
CrosshairT.Thickness = CursorConfig.CrosshairThickness

local CrosshairB = Drawing.new("Line")
CrosshairB.Visible = true
CrosshairB.Transparency = CursorConfig.CrosshairTransparency
CrosshairB.Color = CursorConfig.CrosshairColor
CrosshairB.Thickness = CursorConfig.CrosshairThickness

Render = RunService.RenderStepped:Connect(function()
    if UserInputService.MouseBehavior == Enum.MouseBehavior.Default then
        local Mouse = UserInputService:GetMouseLocation()
        UserInputService.MouseIconEnabled = false

        CursorOutline.PointA = Vector2.new(Mouse.X,Mouse.Y + 16)
        CursorOutline.PointB = Vector2.new(Mouse.X,Mouse.Y)
        CursorOutline.PointC = Vector2.new(Mouse.X + 11,Mouse.Y + 10)

        CursorOutline.Color = CursorConfig.OutlineColor
        CursorOutline.Transparency = CursorConfig.OutlineTransparency

        Cursor.PointA = Vector2.new(Mouse.X,Mouse.Y + 15)
        Cursor.PointB = Vector2.new(Mouse.X,Mouse.Y)
        Cursor.PointC = Vector2.new(Mouse.X + 10,Mouse.Y + 10)

        Cursor.Color = CursorConfig.Color
        Cursor.Transparency = CursorConfig.Transparency

        CrosshairL.Transparency = 0
        CrosshairR.Transparency = 0
        CrosshairT.Transparency = 0
        CrosshairB.Transparency = 0
    else
        local Mouse = UserInputService:GetMouseLocation()
        UserInputService.MouseIconEnabled = false
        
        CursorOutline.Transparency = 0
        Cursor.Transparency = 0

        if CursorConfig.CrosshairEnabled then
            CrosshairL.Color = CursorConfig.CrosshairColor
            CrosshairL.Transparency = CursorConfig.CrosshairTransparency
            CrosshairL.Thickness = CursorConfig.CrosshairThickness
            CrosshairL.From = Vector2.new(Mouse.X - CursorConfig.CrosshairGap,Mouse.Y)
            CrosshairL.To = Vector2.new(Mouse.X - (CursorConfig.CrosshairSize + CursorConfig.CrosshairGap),Mouse.Y)

            CrosshairR.Color = CursorConfig.CrosshairColor
            CrosshairR.Transparency = CursorConfig.CrosshairTransparency
            CrosshairR.Thickness = CursorConfig.CrosshairThickness
            CrosshairR.From = Vector2.new(Mouse.X + (CursorConfig.CrosshairGap + 1),Mouse.Y)
            CrosshairR.To = Vector2.new(Mouse.X + (CursorConfig.CrosshairSize + (CursorConfig.CrosshairGap + 1)),Mouse.Y)

            CrosshairT.Color = CursorConfig.CrosshairColor
            CrosshairT.Transparency = CursorConfig.CrosshairTransparency
            CrosshairT.Thickness = CursorConfig.CrosshairThickness
            CrosshairT.From = Vector2.new(Mouse.X,Mouse.Y - CursorConfig.CrosshairGap)
            CrosshairT.To = Vector2.new(Mouse.X,Mouse.Y - (CursorConfig.CrosshairSize + CursorConfig.CrosshairGap))

            CrosshairB.Color = CursorConfig.CrosshairColor
            CrosshairB.Transparency = CursorConfig.CrosshairTransparency
            CrosshairB.Thickness = CursorConfig.CrosshairThickness
            CrosshairB.From = Vector2.new(Mouse.X,Mouse.Y + (CursorConfig.CrosshairGap + 1))
            CrosshairB.To = Vector2.new(Mouse.X,Mouse.Y + (CursorConfig.CrosshairSize + (CursorConfig.CrosshairGap + 1)))
        else
            CrosshairL.Transparency = 0
            CrosshairR.Transparency = 0
            CrosshairT.Transparency = 0
            CrosshairB.Transparency = 0
        end
    end

    if CursorConfig.DeleteCursor then
        Render:Disconnect()

        CursorOutline:Remove()
        Cursor:Remove()

        CrosshairL:Remove()
        CrosshairR:Remove()
        CrosshairT:Remove()
        CrosshairB:Remove()

        UserInputService.MouseIconEnabled = true
        CursorConfig.DeleteCursor = false
    end

    if CursorConfig.OutlineRainbow then
        local Hue, Saturation, Value = CursorConfig.OutlineColor:ToHSV()
        if Hue == 1 then
            Hue = 0
        end
        CursorConfig.OutlineColor = Color3.fromHSV(Hue + 0.001, 1, 1)
    end
    if CursorConfig.Rainbow then
        local Hue, Saturation, Value = CursorConfig.Color:ToHSV()
        if Hue == 1 then
            Hue = 0
        end
        CursorConfig.Color = Color3.fromHSV(Hue + 0.001, 1, 1)
    end
end)
