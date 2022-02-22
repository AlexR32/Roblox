local Module = {}

local CoreGui = game:GetService("CoreGui")
local Screen = CoreGui:FindFirstChild("NotificationScreen")
local Folder = game:GetObjects("rbxassetid://7231968281")[1]
if not Screen then
	Screen = Folder.NotificationScreen:Clone()
	Screen.Parent = CoreGui
end

local function GetType(Variant, Type)
	if type(Type) == "table" then
		for Index, Value in ipairs(Type) do
			if typeof(Variant) == Value then
				return Variant
			end
		end
	else
		if typeof(Variant) == Type then
			return Variant
		end
	end
end

local function GetLongest(A,B)
	return A > B and A or B
end

function Module:Notification(Title,Description,Duration,Callback)
	Title = GetType(Title,{"string","number"}) or "Title"
	Description = GetType(Description,{"string","number"}) or "Description"
	Callback = GetType(Callback,"function")
	
	local Notification = Folder.Notification:Clone()
	Notification.Parent = Screen.Container
	Notification.Title.Text = Title
	Notification.Description.Text = Description
	Notification.Title.Size = UDim2.new(1,0,0,Notification.Title.TextBounds.Y)
	Notification.Description.Size = UDim2.new(1,0,0,Notification.Description.TextBounds.Y)
	Notification.Size = UDim2.new(0,GetLongest(Notification.Title.TextBounds.X,Notification.Description.TextBounds.X) + 24,0,Notification.ListLayout.AbsoluteContentSize.Y + 8)
	
	if Duration then
		task.spawn(function()
			for Time = Duration,1,-1 do
				Notification.Title.Close.Text = Time
				task.wait(1)
			end
			Notification.Title.Close.Text = 0
			
			if Callback then
				Callback()
			end
			Notification:Destroy()
		end)
	else
		Notification.Title.Close.MouseButton1Click:Connect(function()
			Notification:Destroy()
		end)
	end
end

function Module:TypeWrite(Text,Duration,Duration2)
	local Message = Folder.Message:Clone()
	Message.Parent = Screen.TypeWriter
	Message.Text = Text
	Message.Size = UDim2.new(1,0,0,Message.TextBounds.Y)

	local Index = 0
	local DisplayText = Text
	DisplayText = DisplayText:gsub("<br%s*/>", "\n")
	DisplayText = DisplayText:gsub("<[^<>]->", "")
	
	task.spawn(function()
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
	end)
end

return Module
