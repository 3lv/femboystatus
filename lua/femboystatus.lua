M = { }

local function Set_statusline()
	vim.o.statusline = [[%{luaeval("require('stlfunctions')['file_name']()")}]]
end

M.Set_statusline = Set_statusline

return M
