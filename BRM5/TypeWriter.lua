local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

return function(Text, Wait)
    coroutine.wrap(function()
    local Folder = game:GetObjects("rbxassetid://7231968281")[1]
    local Screen = CoreGui:FindFirstChild("TypeWriter")

    if not Screen then
        Screen = Folder.TypeWriter:Clone()
        Screen.Parent = CoreGui
    end

    local Message = Folder.Message:Clone()
    Message.Parent = Screen.Container
    Message.Text = Text
    Message.Size = UDim2.new(1,0,0,Message.TextBounds.Y)

    local Index = 0
    local DisplayText = Text
    DisplayText = DisplayText:gsub("<br%s*/>", "\n")
    DisplayText = DisplayText:gsub("<[^<>]->", "")

    for _ in utf8.graphemes(DisplayText) do
        Index = Index + 1
        Message.MaxVisibleGraphemes = Index
        wait(0.005)
    end
    wait(Wait)
    for _ in utf8.graphemes(DisplayText) do
        Index = Index - 1
        Message.MaxVisibleGraphemes = Index
        wait(0.005)
    end
    Message:Destroy()
    end)()
end
