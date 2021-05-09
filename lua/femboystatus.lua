M = { }

StatusLine_special_filetype = { NvimTree = 'NvimTree פּ', packer = 'Packer ' }

local fn = vim.fn

local events = { 'ColorScheme', 'FileType','BufWinEnter','BufReadPost','BufWritePost',
                  'BufEnter','WinEnter','FileChangedShellPost','VimResized','TermOpen'}

-- set's status line for current window and a 
-- different status line for other windows
-- (using vim.wo.statusline instead of .o.)


local function generate_StatusLine()
	StatusLine =
'%#'..require('stlfunctions').Icon_hl()..'#'..[[%{luaeval("require('stlfunctions').Icon()")}]].. 
[[ ]]..
[[%#StatusLineFileActive#]]..[[%{luaeval("require('stlfunctions').File()")}]].. 

[[%=]]..

[[%{luaeval("require('stlfunctions').Mode()")}]]..

[[%=]]..

[[%#Normal#]] .. [[fem@boy]]
end

-- Generates a statusline used for current
-- window if window
-- has a buffer with special filetype
-- (usually less important)

local function generate_StatusLine2()

	StatusLine2 =
'%#'..require('stlfunctions').Icon_hl()..'#'..[[%{luaeval("require('stlfunctions').Icon()")}]].. 
[[ ]]..
[[%#StatusLineFileActive#]]..[[%{luaeval("require('stlfunctions').File()")}]].. 

[[%=]]..

[[%=]]..

[[%#Normal#]] .. [[<<<<]]

end

-- generates a statusline for a non current window
-- (Specifically for window with 'winid')
local function generate_StatusLineNC( winid )
	StatusLineNC = 
'%#'..require('stlfunctions').NC_Icon_hl( winid )..'#'..[[%{luaeval("require('stlfunctions').Icon()")}]].. 
[[ ]]..
[[%#StatusLineFileNonActive#]]..[[%{luaeval("require('stlfunctions').File()")}]].. 

[[%=]]..


[[%=]]..

[[%#Normal#]] .. [[<]]
end



local function set_every_statusline()

	nr_of_windows = fn.winnr('$')
	current_winid = fn.win_getid()
	-- find buffer for current window

	-- Setting statusline for non-current windows
	-- (all windows but the curernt one)
	for winnr = 1, nr_of_windows do -- for each window
		-- get the id of window i
		winid = fn.win_getid(winnr)
		if winid ~= current_winid then -- don't set for current window
			-- TODO: check for special windows
			generate_StatusLineNC( winid )
			vim.wo[winid].statusline = StatusLineNC
		end
	end

	current_bufnr = fn.winbufnr(current_winid)
	-- Check for special filetypes
	if StatusLine_special_filetype[vim.bo[current_bufnr].filetype] ~= nil then
		-- Use the status line for special filetypes(a simple statusline)
		generate_StatusLine2()
		vim.wo[current_winid].statusline = StatusLine2
	else
		-- Use the default status line for the current window
		generate_StatusLine()
		vim.wo[current_winid].statusline = StatusLine
	end
end

local async_combin = vim.loop.new_async(vim.schedule_wrap(set_every_statusline))

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
	generate_StatusLine()
	generate_StatusLine2()
	generate_StatusLineNC()

	StatusLine_augroup()

end

M.setup = setup
M.inactive = set_inactive_statusline
M.every = set_every_statusline

return M
