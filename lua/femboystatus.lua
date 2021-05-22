M = { }


local fn = vim.fn

local events = { 'WinEnter', 'BufEnter', 'BufWinEnter', 'BufReadPost', 'BufWritePost',
		 'VimResized', 'FileType', 'Colorscheme', 'FileChangedShellPost', 'TermOpen'}

-- set's status line for current window and a
-- different status line for other windows
-- (using vim.wo.statusline instead of .o.)


local function generate_StatusLine()
	local icon, icon_hl = require('stlfunctions').Icon()
	local filename = require('stlfunctions').File()
	local mod, mod_hl = require('stlfunctions').File_Mod()
	StatusLine =
'%#'..icon_hl..'#'..icon..
[[ ]]..
[[%#StatusLineFileActive#]]..filename..
[[ ]]..
'%#'..'Normal'..'#'..[[%{luaeval("require('stlfunctions').File_Mod()")}]]..

[[%=]]..
[[%#StatusLineMode#]]..[[%{luaeval("require('stlfunctions').Mode()")}]]..[[%#Normal#]]..
[[%=]]..

[[%#LspDiagnosticsDefaultError#]]..[[%-4{luaeval("require('stlfunctions').Error()")}]]..
[[%#Rainbow#]]..[[%10{luaeval("require('stlfunctions').Line_P()")}]]..

'%<'
end

-- Generates a statusline used for current
-- window if window's buffer has a
-- special filetype
-- (usually less important)

local function generate_StatusLine2()
	local icon, icon_hl = require('stlfunctions').Icon()
	local filename = require('stlfunctions').File()
	StatusLine2 =
'%#'..icon_hl..'#'..icon..
[[ ]]..
[[%#StatusLineFileActive#]]..filename..

[[%=]]..
[[%=]]..

[[%#Normal#]] .. [[<<<<]]
..'%<'
end

-- generates a statusline for a non current window
-- (Specifically for window with 'winid')
local function generate_StatusLineNC( winid )
	local icon, icon_hl = require('stlfunctions').Icon()
	local filename = require('stlfunctions').File()
	StatusLineNC =
'%#'..icon_hl..'#'..icon..
[[ ]]..
[[%#StatusLineFileNonActive#]]..filename..
[[ ]]..
'%#'..'Normal'..'#'..[[%{luaeval("require('stlfunctions').File_Mod()")}]]..

[[%=]]..
[[%=]]..

[[%#Normal#]] .. [[<]]
..'%<'
end


local function generate_StatusLineNC2( winid )
	local icon, icon_hl = require('stlfunctions').Icon()
	local filename = require('stlfunctions').File()
	StatusLineNC2 =
'%#'..icon_hl..'#'..icon.. 
[[ ]]..
[[%#StatusLineFileNonActive#]]..filename..

[[%=]]..
[[%=]]..

[[%#Normal#]] .. [[<]]
..'%<'
end



local function set_every_statusline()

	local nr_of_windows = fn.winnr('$')
	local current_winid = fn.win_getid()
	-- find buffer for current window

	-- Setting statusline for non-current windows
	-- (all windows but the curernt one)
	for winnr = 1, nr_of_windows do -- for each window
		-- get the id of window i
		local winid = fn.win_getid(winnr)
		if winid ~= current_winid then -- don't set for current window
			-- TODO: check for special windows
			generate_StatusLineNC( winid )
			vim.wo[winid].statusline = StatusLineNC
		end
	end

	local current_bufnr = fn.winbufnr(current_winid)
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

--local async_combin = vim.loop.new_async(vim.schedule_wrap(set_every_statusline))

-- function used when the current window will no longer be active
-- {event} = WinLeave

local function set_active_startusline()
	-- get current win/buf informations
	local current_winid = fn.win_getid()
	local current_bufnr = fn.winbufnr(current_winid)
	-- Check for special filetypes
	if StatusLine_special_filetype[vim.bo[current_bufnr].filetype] ~= nil then
		-- Use the status line for special filetypes(a simpler statusline)
		generate_StatusLine2()
		vim.wo[current_winid].statusline = StatusLine2
	else
		-- Use the default status line for the current window
		generate_StatusLine()
		vim.wo[current_winid].statusline = StatusLine
	end
end

local function set_inactive_statusline()
	current_winid = fn.win_getid()
	current_bufnr = fn.winbufnr(current_winid)
	if StatusLine_special_filetype[vim.bo[current_bufnr].filetype] ~= nil then
		generate_StatusLineNC2()
		vim.wo.statusline = StatusLineNC2
	else
		generate_StatusLineNC()
		vim.wo.statusline = StatusLineNC
	end
end

local function StatusLine_augroup()
	vim.api.nvim_command('augroup StatusLine')
	vim.api.nvim_command('autocmd!')
	for _,event in ipairs(events) do
		local command = string.format('autocmd %s * lua require("femboystatus").active()', event)
		vim.api.nvim_command(command)
	end
	vim.api.nvim_command('autocmd WinLeave * lua require("femboystatus").inactive()')
	vim.api.nvim_command('augroup END')
end


local function setup( I )
	StatusLine_special_filetype = { NvimTree = 'NvimTree פּ', packer = 'Packer ' }
	vim.api.nvim_command('hi StatusLineFileActive guifg=#b0da6c guibg=NONE gui=bold')
	vim.api.nvim_command('hi StatusLineFileNonActive guifg=#b0da6c guibg=NONE')
	StatusLine_augroup()

end

M.setup = setup
M.active = set_active_startusline
M.inactive = set_inactive_statusline
M.every = set_every_statusline

return M
