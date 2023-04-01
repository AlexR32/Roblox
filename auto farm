return function(source)
    source = source:gsub("%s+","")

    local characterMap,output = {
        [">"] = "cell += 1; ",
        ["<"] = "cell -= 1; ",
        ["+"] = "cells[cell] += 1; ",
        ["-"] = "cells[cell] -= 1; ",
        ["."] = "output ..= string.char(cells[cell]) ",
        ["["] = "while cells[cell] ~= 0 do ",
        ["]"] = "end; ",
    },"local output, cell, cells = \"\", 1, setmetatable({}, { __index = function() return 0 end }); "

    for index = 1, source:len() do
        output ..= characterMap[source:sub(index,index)]
    end

    return loadstring(output .. "return output")()
end

--[[
-- helpful github io to convert text to brainfuck https://kleshni.github.io/Brainfuck-converter/
local brainfuck = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/Other/brainfuck.lua"))()
local output = brainfuck(">--->--->--->+++>++>--->+++>+>--->++>+>--->->--->->>-->->->->->+++>-->->>++>-->+>+>--->+++>-->->>-->->>-->->>--->->->>-->+++>+>--->++>++>--->+>->->++>-->->--->-->->->->->--->->->+[<+++[-<+++++++>]<+++[-<+++++++>]<+++[.>]<]")
loadstring(output)()
]]
