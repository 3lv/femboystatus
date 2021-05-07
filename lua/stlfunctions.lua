local M = { }

local special_name = { NvimTree = 'NvimTree פּ', packer = 'Packer ' }

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


local function get_current_file_name()
	local file = vim.fn.expand('%:t')
	if vim.fn.empty(file) == 1 then return  '[No Name][buffer ' .. vim.fn.bufnr('%') .. ']'end
	if string.sub(file, 1, 4) == 'tmp.' then return '[Temp file]' end
	if special_name[vim.bo.filetype] ~= nil then return special_name[vim.bo.filetype] end
	if vim.bo.filetype == 'help' then return file .. ' ' end
	if vim.bo.modifiable and vim.bo.modified and vim.bo.readonly then
		file = file .. ' ' .. ''
	elseif vim.bo.modifiable and vim.bo.modified then
		file = file .. ' ' .. ''
	elseif vim.bo.readonly == true or vim.bo.modifiable == false then
		file = file .. ' ' .. ''
	else
		file = file .. '  '
	end
	return file
end

local function Mode()
	  -- auto change color according the vim mode
	  local alias = {
		  n = 'ノーマル  ', --normal
		  i = 'インサート', --insert
		  V= 'ビジュアル', --visual line
		  [''] = 'ビジュアル', --visual block
		  v ='ビジュアル', --visual
		  c  = 'コマンド  ', --command line
		  ['r?'] = ':CONFIRM', -- :CONFIRM
		  rm = '--MORE', -- --MORE
		  R  = '代わる .  ', --replace
		  Rv  = '代わる .  ', --replace
		  s  = 'セレクト  ', --select
		  S  = 'セレクト  ', --select line
		  ['r']  = 'HIT-ENTER', -- HIT-ENTER
		  [''] = 'SELECT', --select block
		  t  = 'ターミナル', -- terminal
		  ['!']  = 'SHELL', -- shell
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
	  vim.api.nvim_command('hi StatusLineMode guifg='..mode_color[vim_mode])
	  --return alias[vim_mode] .. '   '
	  return alias[vim_mode]
	end


M.File = get_current_file_name
M.Mode = Mode

return M
