-- original credits to https://github.com/thirteen-io/brainfuck.lua
-- helpful github io to convert text to brainfuck https://kleshni.github.io/Brainfuck-converter/
-- slow as fuck with long code
return function(code)
    -- env string (variables and functions to make compiled code work)
    local env = "local comp = {} local cell = 0 local cells = {} local function g() return (cells[cell] or 0) end local function s(a) cells[cell] = a end local function n() cell = cell + 1 end local function p() cell = cell - 1 end "
    local compile = ""

    -- main part (compiler)
    for index = 1, string.len(code) do
        local sub = string.sub(code, index, index)
        if sub == "+" then
            compile = compile .. "s(g()+1)"
        elseif sub == "-" then
            compile = compile .. "s(g()-1)"
        elseif sub == ">" then
            compile = compile .. "n()"
        elseif sub == "<" then
            compile = compile .. "p()"
        elseif sub == "." then
            compile = compile .. "table.insert(comp,string.char(g()))"
        elseif sub == "[" then
            compile = compile .. "while not(g()==0)do "
        elseif sub == "]" then
            compile = compile .. "end "
        end
    end

    -- env, compiled code and loadstring to combine all things
    return env .. compile .. " loadstring(table.concat(comp,\"\"))()" -- returns kinda obfuscated code which can be executed with loadstring
end
