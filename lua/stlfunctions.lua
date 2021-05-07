local M = { }

local special_name = { NvimTree = 'NvimTree פּ', packer = 'Packer ' }

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


M['file_name'] = get_current_file_name

return M
