-- original credits to https://github.com/thirteen-io/brainfuck.lua
-- helpful github io to convert text to brainfuck https://kleshni.github.io/Brainfuck-converter/
-- slow as fuck with long code
return function(code)
    -- env string (variables and functions to make compiled code work)
    local env = "local comp,cells,cell={},{},0 local function get()return cells[cell]or 0 end local function set(v)cells[cell]=v end local function add()cell=cell+1 end local function sub()cell=cell-1 end "
    local compile = ""

    -- main part (compiler)
    for index = 1, string.len(code) do
        local sub = string.sub(code, index, index)
        if sub == "+" then
            compile = compile .. "set(get()+1)"
        elseif sub == "-" then
            compile = compile .. "set(get()-1)"
        elseif sub == ">" then
            compile = compile .. "add()"
        elseif sub == "<" then
            compile = compile .. "sub()"
        elseif sub == "." then
            compile = compile .. "table.insert(comp,string.char(get()))"
        elseif sub == "[" then
            compile = compile .. "while not(get()==0)do "
        elseif sub == "]" then
            compile = compile .. "end "
        end
    end

    -- combining all things together (loadstring is for executing compiled code)
    -- returns kinda obfuscated code which can be executed with loadstring
    return env .. compile .. "loadstring(table.concat(comp,\"\"))()"
end
