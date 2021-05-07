M = { }

local fn = vim.fn

local events = { 'ColorScheme', 'FileType','BufWinEnter','BufReadPost','BufWritePost',
                  'BufEnter','WinEnter','FileChangedShellPost','VimResized','TermOpen'}

-- set's status line for current window and a 
-- different status line for other windows
-- (using vim.wo.statusline instead of .o.)


local function set_every_statusline()

	nr_of_windows = fn.winnr('$')
	for winnr = 1, nr_of_windows do -- for each window
		-- get the id of window i
		winid = fn.win_getid(winnr)
		-- TODO: check for special windows
		vim.wo[winid].statusline = StatusLineNC
	end

	-- replace for current window
	vim.wo.statusline = StatusLine
end

local function set_inactive_statusline()
	vim.wo.statusline = StatusLineNC
end


local function setup( I )

-- Status line used for CURRENT window
	StatusLine =

[[%{luaeval("require('stlfunctions').File()")}]].. 

[[%=]]..

[[%#StatusLineMode#]] .. [[%{luaeval("require('stlfunctions').Mode()")}]]..

[[%=]]..

[[fem@boy]]

-- Status line used for NOT CURRENT window
	StatusLineNC = 
[[%{luaeval("require('stlfunctions').File()")}]].. 

[[%=]]..


[[%=]]..

[[<]]

	vim.api.nvim_command('augroup StatusLine')
	vim.api.nvim_command('autocmd!')
	for _,event in ipairs(events) do
		local command = string.format('autocmd %s * lua require("femboystatus").every()', event)
		vim.api.nvim_command(command)
	end
	vim.api.nvim_command('autocmd WinLeave * lua require("femboystatus").inactive()')
	vim.api.nvim_command('augroup END')
end

M.setup = setup
M.inactive = set_inactive_statusline
M.every = set_every_statusline

return M
