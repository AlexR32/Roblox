local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local ErrorPrompt = getrenv().require(CoreGui.RobloxGui.Modules.ErrorPrompt)
local function NewScreen(ScreenName)
    local Screen = Instance.new("ScreenGui")
    Screen.Name = ScreenName
    Screen.ResetOnSpawn = false
    Screen.IgnoreGuiInset = true
    sethiddenproperty(Screen,
    "OnTopOfCoreBlur",true)
    syn.protect_gui(Screen)
    Screen.Parent = CoreGui
    return Screen
end

return function(Title,Message,Buttons)
    local Screen = NewScreen("Prompt")
    local Prompt = ErrorPrompt.new("Default",{
        MessageTextScaled = false,
        PlayAnimation = false,
        HideErrorCode = true
    })
    for Index,Button in pairs(Buttons) do
        local Old = Button.Callback
        Button.Callback = function(...)
            RunService:SetRobloxGuiFocused(false)
            Prompt:_close()
            Screen:Destroy()
            return Old(...)
        end
    end

    Prompt:setErrorTitle(Title)
    Prompt:updateButtons(Buttons)
    Prompt:setParent(Screen)
    RunService:SetRobloxGuiFocused(true)
    Prompt:_open(Message)
    return Prompt,Screen
end

--[[
-- Example
local PromptLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/PromptLibrary.lua"))()
ErrorPrompt("Hello!","Would You Like To Be My Friend?",{
    {Text = "Yes",LayoutOrder = 0,Primary = true,Callback = function()
        print(":D")
    end},
    {Text = "No",LayoutOrder = 1,Primary = false,Callback = function()
        print(":(")
    end}
})
]]
