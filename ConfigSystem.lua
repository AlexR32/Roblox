local ConfigSystem = {}
local HttpService = game:GetService("HttpService")

local function Color3ToTable(Color3)
    return {
        ["R"] = Color3.R,
        ["G"] = Color3.G,
        ["B"] = Color3.B
    }
end
local function TableToColor3(Table)
    return Color3.fromRGB(Table["R"] * 255,Table["G"] * 255,Table["B"] * 255)
end

local function EnumToTable(Enum)
    Enum = tostring(Enum)
    Enum = string.split(Enum, ".")
    return Enum
end
local function TableToEnum(Table)
    return Enum[Table[2]][Table[3]]
end

local function ShallowCopy(Table)
    local TableCopy
    if type(Table) == "table" then
        TableCopy = {}
        for Index,Value in pairs(Table) do
            if typeof(Value) == "table" then
                TableCopy[Index] = ShallowCopy(Value)
            else
                TableCopy[Index] = Value
            end
        end
    else
        TableCopy = Table
    end
    return TableCopy
end

local function Convert(Table,Mode)
    if Mode == "Write" then
        for Index,Value in pairs(Table) do
            if typeof(Value) == "Color3" then
                Table[Index] = Color3ToTable(Value)
            elseif typeof(Value) == "EnumItem" then
                Table[Index] = EnumToTable(Value)
            elseif typeof(Value) == "table" then
                Convert(Table[Index],"Write")
            end
        end
    elseif Mode == "Read" then
        for Index,Value in pairs(Table) do
            if typeof(Value) == "table" and (Value["R"] and Value["G"] and Value["B"]) then
                Table[Index] = TableToColor3(Value)
            elseif typeof(Value) == "table" and Value[1] == "Enum" then
                Table[Index] = TableToEnum(Value)
            elseif typeof(Value) == "table" then
                Convert(Table[Index],"Read")
            end
        end
    end
end

local function Compare(Table,Default)
    for Index,Value in pairs(Default) do
        if Table[Index] == nil then
            Table[Index] = Value
            print(tostring(Index) .. " added to config")
        elseif typeof(Table[Index]) == "table" and typeof(Value) == "table" then
            Compare(Table[Index],Value)
        end
    end
    for Index,Value in pairs(Table) do
        if Default[Index] == nil then
            print(tostring(Index) .. " removed from config")
            Table[Index] = nil
        elseif typeof(Default[Index]) == "table" and typeof(Value) == "table" then
            Compare(Default[Index],Value)
        end
    end
end

function ConfigSystem.WriteJSON(Table,Location)
    if not Table and not Location then return end
    local TableCopy = ShallowCopy(Table)
    Convert(TableCopy,"Write")
    writefile(Location, HttpService:JSONEncode(TableCopy))
end

function ConfigSystem.ReadJSON(Location,Default)
    if not Location and not Default then return end
    local Table = HttpService:JSONDecode(readfile(Location))
    Compare(Table,Default)
    Convert(Table,"Read")
    return Table
end

return ConfigSystem
