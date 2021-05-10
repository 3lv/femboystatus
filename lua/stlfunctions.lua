local M = { }


local colors = {
	bg = 'none',
	line_bg = 'none',
	fg = '#8FBCBB',
	fg_green = '#65a380',
	yellow = '#fabd2f',
	cyan = '#008080',
	darkblue = '#081633',
	green = '#afd700',
	orange = '#FF8800',
	purple = '#5d4d7a',
	magenta = '#c678dd',
	blue = '#51afef';
	red = '#ec5f67'
}

local function Rainbow_hl ( )
	if Rainbowid == nil then
		Rainbowid = 0
	end
	Rainbowid = Rainbowid + 1
	if Rainbowid >= 256 * 6 then
		Rainbowid = 0
	end
	local d = Rainbowid % 256
	local slice = Rainbowid / 256
	slice = math.floor( slice )
	local r, g, b = 0, 0, 0
	if slice == 0 then
		r,g,b = 255,     d,       0
	elseif slice == 1 then
		r,g,b = 255 - d, 255,     0
	elseif slice == 2 then
		r,g,b = 0,       255,     d
	elseif slice == 3 then
		r,g,b = 0,       255 - d, 255
	elseif slice == 4 then
		r,g,b = d,       0,       255
	elseif slice == 5 then
		r,g,b = 255,     0,       255 - d
	end
	local hex = string.format("#%02X%02X%02X", r, g, b)
	vim.cmd([[hi Rainbow guifg=]]..hex)
	return 'femboy'
end

local function get_file_icon_hl( winid )
	local bufid = vim.fn.winbufnr(winid)
	local bufcode = '#'..bufid
	local f_name = vim.fn.expand(bufcode..':t')
	local f_extension = vim.fn.expand(bufcode..':e')
	local ok,devicons = pcall(require,'nvim-web-devicons')
	local icon, icon_hl = devicons.get_icon(f_name,f_extension)
	if icon_hl == nil then return 'Normal' end
	return icon_hl

end

-- used only for current window
local function get_file_icon()
	local icon, icon_hl
	if vim.bo.filetype == 'help' then
		icon = icon or ''
		icon_hl = icon_hl or 'Normal'
	end
	if StatusLine_special_filetype[vim.bo.filetype] ~= nil then
		icon = icon or ''
		icon_hl = icon_hl or 'Normal'
	end
	local ok,devicons = pcall(require,'nvim-web-devicons')
	if not ok then print([[Install 'kyazdani42/nvim-web-devicons' to use icons]]) return '' end
	local f_name,f_extension = vim.fn.expand('%:t'), vim.fn.expand('%:e')
	local devicon, devicon_hl = devicons.get_icon(f_name,f_extension)
	icon = icon or devicon or ''
	icon_hl = icon_hl or devicon_hl or 'Normal'
	return icon, icon_hl
end

-- used only for current window
local function get_current_file_icon_hl()
	if StatusLine_special_filetype[vim.bo.filetype] ~= nil then
		return 'Normal'
	end
	local f_name,f_extension = vim.fn.expand('%:t'), vim.fn.expand('%:e')
	local ok,devicons = pcall(require,'nvim-web-devicons')
	local icon, icon_hl = devicons.get_icon(f_name,f_extension)
	if icon_hl == nil then return 'Normal' end
	return icon_hl
end


local function get_current_file_name()
	local file = vim.fn.expand('%:t')
	if vim.fn.empty(file) == 1 then file = '[No Name][buffer ' .. vim.fn.bufnr('%') .. ']' end
	if string.sub(file, 1, 4) == 'tmp.' then file = '[Temp file]' end
	if StatusLine_special_filetype[vim.bo.filetype] ~= nil then file = StatusLine_special_filetype[vim.bo.filetype] end
	return file
end

local function get_current_file_modifier ( )
	local modicon = ' '
	local modicon_hl = 'Normal'
	if vim.bo.modifiable and vim.bo.modified and vim.bo.readonly then
		modicon = ''
	elseif vim.bo.modifiable and vim.bo.modified then
		modicon = ''
	elseif vim.bo.readonly == true or vim.bo.modifiable == false then
		modicon = ''
	end
	return modicon, modicon_hl
end

local function Mode()
	  -- auto change color according the vim mode
	  local alias = {
		  n = '\ ノーマル\ ', --normal
		  i = 'インサート', --insert
		  c = ' コマンド ', --command line
		  v = 'ビジュアル', --visual
		  V = 'ビジュアル', --visual line
		  [''] = 'ビジュアル', --visual block
		  R  = '  代わる  ', --replace
		  Rv  = '  代わる  ', --replace visual
		  s  = ' セレクト ', --select
		  S  = ' セレクト ', --select line
		  [''] = ' セレクト ', --select block
		  t  = 'ターミナル', -- terminal
		  ['r']  = 'HIT-ENTER', -- HIT-ENTER
		  ['!']  = 'SHELL', -- shell
		  ['r?'] = ':CONFIRM', -- :CONFIRM
		  rm = '--MORE', -- --MORE
	  }
	  local mode_color = {
		  n = colors.green,
		  i = colors.blue,v=colors.magenta,[''] = colors.blue,V=colors.blue,
		  c = colors.red,no = colors.magenta,s = colors.orange,S=colors.orange,
		  [''] = colors.orange,ic = colors.yellow,R = colors.purple,Rv = colors.purple,
		  cv = colors.red,ce=colors.red, r = colors.cyan,rm = colors.cyan, ['r?'] = colors.cyan,
		  ['!']  = colors.green,t = colors.green,
		  c  = colors.purple,
		  ['r?'] = colors.red,
		  ['r']  = colors.red,
		  rm = colors.red,
		  R  = colors.yellow,
		  Rv = colors.magenta,
	  }
	  local vim_mode = vim.fn.mode()
	  vim.api.nvim_command('hi StatusLineMode guifg='..mode_color[vim_mode]..' gui=bold')
	  --return alias[vim_mode] .. '   '
	  return alias[vim_mode]
end


M.File_Mod = get_current_file_modifier
M.File = get_current_file_name
M.Mode = Mode
M.Icon = get_file_icon
M.Icon_hl = get_current_file_icon_hl
M.NC_Icon_hl = get_file_icon_hl
M.Rainbow = Rainbow_hl

return M
