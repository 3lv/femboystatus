M = { }

local function setup()
	vim.o.statusline = 
[[%{luaeval("require('stlfunctions').File()")} %= %{luaeval("require('stlfunctions').Mode()")}]]
end

M.setup = setup

return M
