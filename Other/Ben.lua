
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChatEvents = ReplicatedStorage.DefaultChatSystemChatEvents
local OnMessageDoneFiltering = ChatEvents.OnMessageDoneFiltering
local SayMessageRequest = ChatEvents.SayMessageRequest
local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer

getgenv().BenConfig = {Whisper = false}
local Answers = {"Yes.","No.","Hohoho.","Ough."}

local function ChatToPlayer(Player,Message)
    Message = BenConfig.Whisper and ("/w " .. Player.Name .. " " .. Message) or Message
    SayMessageRequest:FireServer(Message, "All")
end

local function Match(Message,Format)
    return string.match(string.lower(Message),Format)
end

local function Answer(Player,Message)
    --if not Match(Message,"^/") then
        local Random = math.random(1,#Answers)
        ChatToPlayer(Player,Answers[Random])
    --end
end

OnMessageDoneFiltering.OnClientEvent:Connect(function(Data)
    local Player = PlayerService[Data.FromSpeaker]
    if Player == LocalPlayer then return end
    Answer(Player,Data.Message)
end)
