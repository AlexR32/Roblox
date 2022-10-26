local LogTable = {"Remote Log Started - " .. os.date("%c")}
local PlayerService = game:GetService("Players")

local SpecialCharacters,Keywords = {
    ['\a'] = '\\a',
    ['\b'] = '\\b',
    ['\f'] = '\\f',
    ['\n'] = '\\n',
    ['\r'] = '\\r',
    ['\t'] = '\\t',
    ['\v'] = '\\v',
    ['\0'] = '\\0'
}, {
    ['and'] = true,
    ['break'] = true,
    ['do'] = true,
    ['else'] = true,
    ['elseif'] = true,
    ['end'] = true,
    ['false'] = true,
    ['for'] = true,
    ['function'] = true,
    ['if'] = true,
    ['in'] = true,
    ['local'] = true,
    ['nil'] = true,
    ['not'] = true,
    ['or'] = true,
    ['repeat'] = true,
    ['return'] = true,
    ['then'] = true,
    ['true'] = true,
    ['until'] = true,
    ['while'] = true,
    ['continue'] = true
}

local function GetFullName(Object)
    local Hierarchy = {}

    local ChainLength = 1
    local Parent = Object

    while Parent do
        Parent = Parent.Parent
        ChainLength = ChainLength + 1
    end

    Parent = Object
    local Num = 0
    while Parent do
        Num = Num + 1

        local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters)
        ObjName = Parent == game and 'game' or ObjName

        if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then
            ObjName = '["' .. ObjName .. '"]'
        elseif Num ~= ChainLength - 1 then
            ObjName = '.' .. ObjName
        end

        Hierarchy[ChainLength - Num] = ObjName
        Parent = Parent.Parent
    end

    return table.concat(Hierarchy)
end

local function formatargs(args,showkeys)
    if #args == 0 then return "N/A" end
    local strargs = {}
    for k,v in next,args do
        local argstr = ""
        if type(v) == "string" then
            argstr = "\"" .. v .. "\""
        elseif typeof(v) == "Instance" then
            argstr = "game."..v:GetFullName()
        elseif type(v) == "table" then
            argstr = "{" .. formatargs(v,true) .. "}"
        else
            argstr = tostring(v)
        end
        if showkeys and type(k) ~= "number" then
            table.insert(strargs,k.."="..argstr)
        else
            table.insert(strargs,argstr)
        end
    end
    return table.concat(strargs, ", ")
end

local function RemoteLog(Self, Method, Script, Args)
    local SelfName = GetFullName(Self)
    local FormatedArgs = formatargs(Args)

    LogTable[#LogTable + 1] = string.format("%s called! - %s\nPath: %s\nFrom Script: %s\nArguments: %s\nRuns As: %s:%s(%s)",
        Self.ClassName,os.date("%c"),SelfName,GetFullName(Script),FormatedArgs,SelfName,Method,FormatedArgs)
end

PlayerService.PlayerRemoving:Connect(function(Player)
    if Player == PlayerService.LocalPlayer then
        LogTable[#LogTable + 1] = "Remote Log Ended - " .. os.date("%c")
        writefile("Remote Log.txt", table.concat(LogTable,"\n\n"))
    end
end)

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Method,Script,Args = getnamecallmethod(),getcallingscript(),{...}
    if Method == "FireServer" or Method == "InvokeServer" then
        task.spawn(function()
            RemoteLog(Self, Method, Script, Args)
        end)
    end return OldNamecall(Self, ...)
end)
