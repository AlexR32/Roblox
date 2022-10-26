local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local function MakeDraggable(TopbarObject, Object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil
	
	TopbarObject.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPosition = Object.Position
			
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)
	
	TopbarObject.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - DragStart
			Object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		end
	end)
end

local Screen = game:GetObjects("rbxassetid://6503762610")[1]
local Main = Screen.Main

local ButtonFrame = Main.ButtonFrame
local TextFrame = Main.TextFrame
local TopFrame = Main.TopFrame

local PlayButton = ButtonFrame.PlayButton
local PauseButton = ButtonFrame.PauseButton
local StopButton = ButtonFrame.StopButton

local SheetBox = TextFrame.TextBox
local KeyDelay = TopFrame.KeyDelay
local KeyCount = TopFrame.KeyCount

Screen.Name = HttpService:GenerateGUID(false)
Screen.Parent = CoreGui

local UIToggle = true
MakeDraggable(TopFrame, Main)

local SpecialNotes = {
	"!",
	"@",
	"$",
	"%",
	"^",
	"*",
	"("
}

_G.ASCII = {
	["a"] = 0x41,
	["b"] = 0x42,
	["c"] = 0x43,
	["d"] = 0x44,
	["e"] = 0x45,
	["f"] = 0x46,
	["g"] = 0x47,
	["h"] = 0x48,
	["i"] = 0x49,
	["j"] = 0x4A,
	["k"] = 0x4B,
	["l"] = 0x4C,
	["m"] = 0x4D,
	["n"] = 0x4E,
	["o"] = 0x4F,
	["p"] = 0x50,
	["q"] = 0x51,
	["r"] = 0x52,
	["s"] = 0x53,
	["t"] = 0x54,
	["u"] = 0x55,
	["v"] = 0x56,
	["w"] = 0x57,
	["x"] = 0x58,
	["y"] = 0x59,
	["z"] = 0x5A,
	["0"] = 0x30,
	["1"] = 0x31,
	["2"] = 0x32,
	["3"] = 0x33,
	["4"] = 0x34,
	["5"] = 0x35,
	["6"] = 0x36,
	["7"] = 0x37,
	["8"] = 0x38,
	["9"] = 0x39,
	["!"] = 0x31,
	["@"] = 0x32,
	["$"] = 0x34,
	["%"] = 0x35,
	["^"] = 0x36,
	["*"] = 0x38,
	["("] = 0x39
}

function ShiftKey(Key)
	local ASCIIKey = _G.ASCII[Key]
	keypress(0xA0)
	keypress(ASCIIKey)
	keyrelease(0xA0)
	keyrelease(ASCIIKey)
end

PlayButton.MouseButton1Click:Connect(function()
	local Count = 0
	Stop = false
	Paused = false
	GroupNote = false
	Speed = tonumber(KeyDelay.Text)
	PauseButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	

	C = coroutine.create(function()
		for Notes in SheetBox.Text:gmatch("[^%.]") do
		    
			if Paused then
				coroutine.yield()
			end
			
			if Stop == true then
				Stop = false
				break
			end

			local SpecialPlay = false
			local DefaultSpeed = tonumber(KeyDelay.Text)

			if Notes == "[" then
				GroupNote = true
				Speed = 0
			elseif Notes == "]" then
				GroupNote = false
				Speed = DefaultSpeed
			elseif Notes == "|" then
				wait(0.5)
			elseif Notes == "{" then
				Speed = Speed / 2
			elseif Notes == "}" then
				Speed = DefaultSpeed
			elseif Notes == " " then
				wait(Speed + 0.01)
			end

			for SNote = 1, #SpecialNotes do
				if Notes == SpecialNotes[SNote] then
					ShiftKey(Notes)
					SpecialPlay = true
				end
			end

			if not SpecialPlay and not Paused then
				if Notes:match("%w" or "%d") then
					local Press = _G.ASCII[Notes:lower()]
					if not Notes:match("%d") and Notes == Notes:upper() then
						keypress(0xA0)
						keypress(Press)
						keyrelease(0xA0)
						keyrelease(Press)
					else
						keypress(Press)
						keyrelease(Press)
					end 
				end
			end

			wait(tonumber(Speed))
			Count = Count + 1
			KeyCount.Text = "[" .. Count .. "/" .. #SheetBox.Text .. "]"
		end
	end)
	coroutine.resume(C)
end)

StopButton.MouseButton1Click:Connect(function()
	Stop = true
end)

PauseButton.MouseButton1Click:Connect(function()
	if Paused then 
		Paused = false
		PauseButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		coroutine.resume(C)
	else
		Paused = true
		PauseButton.BackgroundColor3 = Color3.fromRGB(70, 35, 35)
		coroutine.resume(C)
	end
end)

UserInputService.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.Up then
		Speed = Speed + 0.01
		KeyDelay.Text = Speed
	elseif Input.KeyCode == Enum.KeyCode.Down then
		Speed = Speed - 0.01
		KeyDelay.Text = Speed
	end
	if Input.KeyCode == Enum.KeyCode.Insert then
		if UIToggle == true then
			UIToggle = false
			Main.Visible = true
		else
			UIToggle = true
			Main.Visible = false
		end
	end
end)
