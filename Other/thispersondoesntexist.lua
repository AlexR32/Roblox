local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local ThisDoesntExist = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Image = Instance.new("ImageLabel")
local Corner = Instance.new("UICorner")
local Cat = Instance.new("ImageButton")
local Corner_2 = Instance.new("UICorner")
local Person = Instance.new("ImageButton")
local Corner_3 = Instance.new("UICorner")
local Waifu = Instance.new("ImageButton")
local Corner_4 = Instance.new("UICorner")
local Mode = Instance.new("TextLabel")
local Corner_5 = Instance.new("UICorner")
local ImageInfo = Instance.new("TextLabel")

ThisDoesntExist.Name = "ThisDoesntExist"
ThisDoesntExist.Parent = CoreGui

Main.Name = "Main"
Main.Parent = ThisDoesntExist
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 500, 0, 500)

Image.Name = "Image"
Image.Parent = Main
Image.AnchorPoint = Vector2.new(0.5, 0)
Image.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Image.BackgroundTransparency = 1.000
Image.BorderColor3 = Color3.fromRGB(0, 0, 0)
Image.BorderSizePixel = 0
Image.Position = UDim2.new(0.5, 0, 0, 5)
Image.Size = UDim2.new(1, -10, 1, -65)

Corner.Name = "Corner"
Corner.Parent = Image

Cat.Name = "Cat"
Cat.Parent = Main
Cat.AnchorPoint = Vector2.new(1, 1)
Cat.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Cat.BorderColor3 = Color3.fromRGB(0, 0, 0)
Cat.BorderSizePixel = 0
Cat.Position = UDim2.new(1, -60, 1, -5)
Cat.Size = UDim2.new(0, 50, 0, 50)
Cat.Image = "rbxassetid://7118481437"
Cat.ScaleType = Enum.ScaleType.Fit

Corner_2.Name = "Corner"
Corner_2.Parent = Cat

Person.Name = "Person"
Person.Parent = Main
Person.AnchorPoint = Vector2.new(1, 1)
Person.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Person.BorderColor3 = Color3.fromRGB(0, 0, 0)
Person.BorderSizePixel = 0
Person.Position = UDim2.new(1, -115, 1, -5)
Person.Size = UDim2.new(0, 50, 0, 50)
Person.Image = "rbxassetid://7118685265"
Person.ScaleType = Enum.ScaleType.Fit

Corner_3.Name = "Corner"
Corner_3.Parent = Person

Waifu.Name = "Waifu"
Waifu.Parent = Main
Waifu.AnchorPoint = Vector2.new(1, 1)
Waifu.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Waifu.BorderColor3 = Color3.fromRGB(0, 0, 0)
Waifu.BorderSizePixel = 0
Waifu.Position = UDim2.new(1, -5, 1, -5)
Waifu.Size = UDim2.new(0, 50, 0, 50)
Waifu.Image = "rbxassetid://7118710803"
Waifu.ScaleType = Enum.ScaleType.Fit

Corner_4.Name = "Corner"
Corner_4.Parent = Waifu

Mode.Name = "Mode"
Mode.Parent = Main
Mode.AnchorPoint = Vector2.new(0.5, 1)
Mode.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Mode.BackgroundTransparency = 1.000
Mode.BorderColor3 = Color3.fromRGB(0, 0, 0)
Mode.BorderSizePixel = 0
Mode.Position = UDim2.new(0.5, 0, 1, -30)
Mode.Size = UDim2.new(1, -10, 0, 25)
Mode.Font = Enum.Font.Oswald
Mode.Text = ""
Mode.TextColor3 = Color3.fromRGB(255, 255, 255)
Mode.TextSize = 25.000
Mode.TextWrapped = true
Mode.TextXAlignment = Enum.TextXAlignment.Left

Corner_5.Name = "Corner"
Corner_5.Parent = Main

ImageInfo.Name = "ImageInfo"
ImageInfo.Parent = Main
ImageInfo.AnchorPoint = Vector2.new(0.5, 1)
ImageInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageInfo.BackgroundTransparency = 1.000
ImageInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageInfo.BorderSizePixel = 0
ImageInfo.Position = UDim2.new(0.5, 0, 1, -5)
ImageInfo.Size = UDim2.new(1, -10, 0, 15)
ImageInfo.Font = Enum.Font.Oswald
ImageInfo.Text = ""
ImageInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
ImageInfo.TextSize = 15.000
ImageInfo.TextWrapped = true
ImageInfo.TextXAlignment = Enum.TextXAlignment.Left

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

MakeDraggable(Main,Main)

local function getAsset(url)
    if not url then return end
    if isfolder("Images") then
        local Name = "Images/Image [" .. HttpService:GenerateGUID(false) .. "].png"
        if not isfile(Name) then
            writefile(Name, game:HttpGet(url))
            return getsynasset(Name), Name
        else
            return getAsset(url)
        end
    else
        makefolder("Images")
        return getAsset(url)
    end
end

local function image(site)
    if site == "person" then
        local ImageUrl, Name = getAsset("https://thispersondoesnotexist.com/image")
        Image.Image = ImageUrl
        ImageInfo.Text = Name
        Mode.Text = "This person doesnt exist"
    end

    if site == "cat" then
        local ImageUrl, Name = getAsset("https://thiscatdoesnotexist.com")
        Image.Image = ImageUrl
        ImageInfo.Text = Name
        Mode.Text = "This cat doesnt exist"
    end

    if site == "waifu" then
        local ImageUrl, Name = getAsset("https://thisanimedoesnotexist.ai/results/psi-0.3/seed" .. tostring(math.random(1,99999)) .. ".png")--getAsset("https://www.thiswaifudoesnotexist.net/example-" .. tostring(math.random(1,100000)) .. ".jpg")
        Image.Image = ImageUrl
        ImageInfo.Text = Name
        Mode.Text = "This anime doesnt exist"
    end
end

Person.MouseButton1Click:Connect(function()
    image("person")
end)

Cat.MouseButton1Click:Connect(function()
    image("cat")
end)

Waifu.MouseButton1Click:Connect(function()
    image("waifu")
end)
