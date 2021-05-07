M = { }

local fn = vim.fn

-- set's status line for current window and a 
-- different status line for other windows
-- (using vim.wo.statusline instead of .o.)
local function set_statusline()

	nr_of_windows = fn.winnr('$')
	for winnr = 1, nr_of_windows do -- for each window
		-- get the id of window i
		winid = fn.win_getid(winnr)
		-- TODO: check for special windows
		vim.wo[winid].statusline = StatusLineNC
	end

	-- now for current window
	vim.wo.statusline = StatusLine
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

	set_statusline()
end

M.setup = setup

return M
