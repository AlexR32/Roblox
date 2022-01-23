local Module = {}

local function GetLongest(Number1,Number2)
	if Number1 > Number2 then
		return Number1
	else
		return Number2
	end
end

function Module.Notification(Title,Text,Duration)
	local CoreGui = game:GetService("CoreGui")
	local Screen = CoreGui:FindFirstChild("NotificationScreen")
	local Folder = game:GetObjects("rbxassetid://7231968281")[1]
	if not Screen then
		Screen = Folder.NotificationScreen:Clone()
		Screen.Parent = CoreGui
	end
	
	for Index,OldNotification in pairs(Screen.Container:GetChildren()) do
		local Position = UDim2.new(1,0,1,(OldNotification.Position.Y.Offset - OldNotification.Size.Y.Offset) - 10)
		OldNotification:TweenPosition(Position,Enum.EasingDirection.InOut,Enum.EasingStyle.Linear,0.1,true)
	end
	
	local Notification = Folder.Notification:Clone()
	Notification.Parent = Screen.Container
	Notification.Title.Text = Title
	Notification.Text.Text = Text
	Notification.Title.Size = UDim2.new(1,-10,0,Notification.Title.TextBounds.Y)
	Notification.Text.Position = UDim2.new(0.5,0,0,Notification.Title.Size.Y.Offset + 5)
	Notification.Text.Size = UDim2.new(1,-10,0,Notification.Text.TextBounds.Y)
	Notification.Size = UDim2.new(0,GetLongest(Notification.Title.TextBounds.X,Notification.Text.TextBounds.X) + 10,0,(Notification.Title.Size.Y.Offset + Notification.Text.Size.Y.Offset) + 10)
	Notification.Position = UDim2.new(1,Notification.Size.X.Offset + 10,1,0)
	Notification:TweenPosition(UDim2.new(1,0,1,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Linear,0.1,true)
	
	task.delay(Duration,function()
		Notification:TweenPosition(UDim2.new(1,Notification.Size.X.Offset + 10,1,Notification.Position.Y.Offset),Enum.EasingDirection.InOut,Enum.EasingStyle.Linear,0.1,true)
		task.wait(0.25)
		Notification:Destroy()
	end)
end

function Module.TypeWrite(Text,Duration,Duration2)
	--coroutine.wrap(function()
		local CoreGui = game:GetService("CoreGui")
		local Screen = CoreGui:FindFirstChild("NotificationScreen")
		local Folder = game:GetObjects("rbxassetid://7231968281")[1]
		if not Screen then
			Screen = Folder.NotificationScreen:Clone()
			Screen.Parent = CoreGui
		end

		local Message = Folder.Message:Clone()
		Message.Parent = Screen.TypeWriter
		Message.Text = Text
		Message.Size = UDim2.new(1,0,0,Message.TextBounds.Y)

		local Index = 0
		local DisplayText = Text
		DisplayText = DisplayText:gsub("<br%s*/>", "\n")
		DisplayText = DisplayText:gsub("<[^<>]->", "")

		for _ in utf8.graphemes(DisplayText) do
			Index = Index + 1
			Message.MaxVisibleGraphemes = Index
			task.wait(Duration2)
		end
		task.delay(Duration,function()
			for _ in utf8.graphemes(DisplayText) do
				Index = Index - 1
				Message.MaxVisibleGraphemes = Index
				task.wait(Duration2)
			end
			Message:Destroy()
		end)
	--end)()
end

return Module
