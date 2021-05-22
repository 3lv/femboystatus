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

local numbers = { '一', '二', '三', '四', '五', '六', '七', '八', '九', '十'}
numbers[0] = '零'
numbers[100] = '百'

local function japanese_number( number )
	local j_number
	if number <= 9 then
		j_number = numbers[number]
	elseif number <= 99 then
		local d1, d2 = math.floor(number / 10), number % 10
		local j_d1, j_d2 = '', ''
		if d1 == 0 then
			j_d1 = ''
		elseif d1 == 1 then
			j_d1 = numbers[10]
		else
			j_d1 = numbers[d1]..numbers[10]
		end
		if d2 == 0 then
			j_d2 = ''
		else
			j_d2 = numbers[d2]
		end
		j_number = j_d1..j_d2
	end
	return j_number
end

local function current_line_percent()
	local current_line = vim.fn.line('.')
	local total_line = vim.fn.line('$')
	if current_line == 1 then
		return '  上 '
	elseif current_line == vim.fn.line('$') then
		return '  下 '
	end
	local percentage,_ = math.modf((current_line/total_line)*100)
	local j_percentage = japanese_number(percentage)
	return j_percentage..' '..'厘'
end

local function get_nvim_lsp_diagnostic( diag_type )
	if next(vim.lsp.buf_get_clients(0)) == nil then
		return 0
	end
	local active_clients = vim.lsp.get_active_clients()
	if active_clients then
		local count = 0
		for _, client in ipairs(active_clients) do
			count = count + vim.lsp.diagnostic.get_count(0, diag_type, client.id)
		end
		if count ~= 0 then
			return count
		end
	end
	return 0

end

local function get_diagnostic_error()
	if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
		local error_nr = get_nvim_lsp_diagnostic( 'Error' )
		if error_nr > 0 then
			return ' '..get_nvim_lsp_diagnostic( 'Error' )
		end
	end
	return ' '
end


local function get_file_icon_hl( winid )
	local bufid = vim.fn.winbufnr(winid)
	local bufname = vim.fn.bufname(bufid)
	local f_name = vim.fn.fnamemodify(bufname, ':t')
	local f_extension = vim.fn.fnamemodify(bufname, ':e')
	local ok,devicons = pcall(require,'nvim-web-devicons')
	local icon, icon_hl = devicons.get_icon(f_name,f_extension)
	icon_hl = icon_hl or 'Normal'
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
	if vim.fn.empty(file) == 1 then file = '[No Name]' end
	if string.sub(file, 1, 4) == 'tmp.' then file = '[Temp file]' end
	if StatusLine_special_filetype[vim.bo.filetype] ~= nil then file = StatusLine_special_filetype[vim.bo.filetype] end
	file = file .. ' [b' .. vim.fn.bufnr('%') .. ']'
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
		  n = '  ノーマル ', --normal
		  i = ' インサート', --insert
		  c = '  コマンド ', --command line
		  v = ' ビジュアル', --visual
		  V = ' ビジュアル', --visual line
		  [''] = ' ビジュアル', --visual block
		  R  = '   代わる  ', --replace
		  Rv  = '   代わる  ', --replace visual
		  s  = '  セレクト ', --select
		  S  = '  セレクト ', --select line
		  [''] = '  セレクト ', --select block
		  t  = ' ターミナル', -- terminal
		  ['r']  = 'HIT-ENTER', -- HIT-ENTER
		  ['!']  = 'SHELL', -- shell
		  ['r?'] = ':CONFIRM', -- :CONFIRM
		  rm = '--MORE', -- --MORE
	  }
	  local mode_color = {
		  n = colors.green,
		  i = colors.blue,
		  v = colors.magenta,[''] = colors.magenta,V = colors.magenta,
		  R  = colors.yellow,
		  s = colors.orange,S=colors.orange, [''] = colors.orange,
		  t = colors.red,
		  c  = colors.purple,
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
M.Error = get_diagnostic_error
M.Line_P = current_line_percent

return M
