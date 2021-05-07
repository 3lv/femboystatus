M = { }

local function Call_Predefined_Function( Function_Name )
	return require('femboystatus.functions')[Function_Name]()
end

local function Set_statusline()
	vim.wo.statusline = [[%{luaeval("require('stlfunctions')['file_name']())]]
end

M.Function = Call_Predefined_Function()
M.Set_statusline = Set_statusline()

return M
