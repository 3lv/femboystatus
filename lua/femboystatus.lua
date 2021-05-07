M = { }

local function setup()
	vim.o.statusline = 
[[%{luaeval("require('stlfunctions').File()")}]].. 
[[%=]]..
[[%#StatusLineMode#[[%{luaeval("require('stlfunctions').Mode()")}]]..
[[%=]]..
[[fem@boy]]
end

M.setup = setup

return M
