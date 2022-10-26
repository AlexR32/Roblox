local InsertService = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

if not TW then
	getgenv().TW = {}
	TW.MainModule = InsertService:LoadLocalAsset("rbxassetid://7231968281")
	TW.Screen = TW.MainModule.Screen:Clone()
	TW.Screen.Name = "TW " .. HttpService:GenerateGUID(false)
	TW.Screen.Parent = CoreGui
end

return function(Text,Duration,Duration2)
	local Message = TW.MainModule.Message:Clone()
	Message.Parent = TW.Screen
	Message.Text = Text
	Message.Size = UDim2.new(1,0,0,Message.TextBounds.Y)

	local Index = 0
	local DisplayText = Text
	DisplayText = DisplayText:gsub("<br%s*/>", "\n")
	DisplayText = DisplayText:gsub("<[^<>]->", "")

	coroutine.wrap(function()
		for _ in utf8.graphemes(DisplayText) do
			Index = Index + 1
			Message.MaxVisibleGraphemes = Index
			task.wait(Duration2)
		end
		task.wait(Duration)
		for _ in utf8.graphemes(DisplayText) do
			Index = Index - 1
			Message.MaxVisibleGraphemes = Index
			task.wait(Duration2)
		end
		Message:Destroy()
	end)()
end
