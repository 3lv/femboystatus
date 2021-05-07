M = { }

StatusLine_special_filetype = { NvimTree = 'NvimTree פּ', packer = 'Packer ' }

local fn = vim.fn

local events = { 'ColorScheme', 'FileType','BufWinEnter','BufReadPost','BufWritePost',
                  'BufEnter','WinEnter','FileChangedShellPost','VimResized','TermOpen'}

-- set's status line for current window and a 
-- different status line for other windows
-- (using vim.wo.statusline instead of .o.)

local function set_every_statusline()

	nr_of_windows = fn.winnr('$')
	current_winid = fn.win_getid()
	print (current_winid)
	-- Setting statusline for non-current windows
	-- (all windows but the curernt one)
	for winnr = 1, nr_of_windows do -- for each window
		-- get the id of window i
		winid = fn.win_getid(winnr)
		if winid ~= current_winid then -- don't set for current window
			-- TODO: check for special windows
			vim.wo[winid].statusline = StatusLineNC
		end
	end

	-- set for current window
	current_bufnr = fn.winbufnr(current_winid)
	-- Check for special filetypes
	if StatusLine_special_filetype[vim.bo[current_bufnr].filetype] ~= nil then
		-- Use the status line for special filetypes
		vim.wo[current_winid].statusline = StatusLine2
	else
		-- Use the default status line for the current window
		vim.wo[current_winid].statusline = StatusLine
	end
end

-- function used when the current window will no longer be active
-- {event} = WinLeave
local function set_inactive_statusline()
	vim.wo.statusline = StatusLineNC
end

local function StatusLine_augroup()
	vim.api.nvim_command('augroup StatusLine')
	vim.api.nvim_command('autocmd!')
	for _,event in ipairs(events) do
		local command = string.format('autocmd %s * lua require("femboystatus").every()', event)
		vim.api.nvim_command(command)
	end
	vim.api.nvim_command('autocmd WinLeave * lua require("femboystatus").inactive()')
	vim.api.nvim_command('augroup END')
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
	StatusLine2 =
[[%{luaeval("require('stlfunctions').File()")}]].. 

[[%=]]..


[[%=]]..

[[<<<]]

	StatusLine_augroup()

end

M.setup = setup
M.inactive = set_inactive_statusline
M.every = set_every_statusline

return M
