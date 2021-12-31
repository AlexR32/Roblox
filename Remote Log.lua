local logtable = {"Remote Log Started - " .. os.date("%c")}

local SpecialCharacters = {
	['\a'] = '\\a', 
	['\b'] = '\\b', 
	['\f'] = '\\f', 
	['\n'] = '\\n', 
	['\r'] = '\\r', 
	['\t'] = '\\t', 
	['\v'] = '\\v', 
	['\0'] = '\\0'
}
local Keywords = { 
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

function formatargs(args,showkeys)
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

local function remotelog(self, namecallmethod, script, args)
    table.insert(logtable, #logtable + 1, self.ClassName .. " called! - " .. os.date("%c") .. "\nPath: " .. GetFullName(self) .. "\nFrom Script: " .. GetFullName(script) .. "\nArguments: " .. formatargs(args) .. "\nRuns As: " .. GetFullName(self) .. ":" .. namecallmethod .. "(" .. formatargs(args) .. ")")
end

game.Players.PlayerRemoving:Connect(function(Player)
    if Player == game.Players.LocalPlayer then
        table.insert(logtable, #logtable + 1, "Remote Log Ended - " .. os.date("%c"))
        writefile("Remote Log.txt", table.concat(logtable,"\n\n"))
    end
end)

namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local namecallmethod = getnamecallmethod()
    local script = getcallingscript()
    local args = {...}
    if namecallmethod == "FireServer" or namecallmethod == "InvokeServer" then
        remotelog(self, namecallmethod, script, args)
    end
    return namecall(self, ...)
end)
