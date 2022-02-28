-- original credits to https://github.com/thirteen-io/brainfuck.lua
return function(code)
	local comp = ""
	local env = "local comp = {} local cell = 0 local cells = {} local function g() return (cells[cell] or 0) end local function s(a) cells[cell] = a end local function n() cell = cell + 1 end local function p() cell = cell - 1 end "
	
	for i = 1, string.len(code) do
		local c = string.sub(code, i, i)
		if ( c == "+" ) then
			comp = comp.."s(g()+1)"
		elseif ( c == "-" ) then
			comp = comp.."s(g()-1)"
		elseif ( c == ">" ) then
			comp = comp.."n()"
		elseif ( c == "<" ) then
			comp = comp.."p()"
		elseif ( c == "." ) then
			comp = comp.."table.insert(comp,string.char(g()))"
		elseif ( c == "," ) then
			comp = comp.."s(string.byte(io.read(1)))"
		elseif ( c == "[" ) then
			comp = comp.."while not(g()==0)do "
		elseif ( c == "]" ) then
			comp = comp.."end "
		end
	end
	
	return env .. comp .. " loadstring(table.concat(comp,''))()"
end
