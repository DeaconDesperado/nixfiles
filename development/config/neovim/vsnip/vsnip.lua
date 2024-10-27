local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t('<C-n>')
	elseif vim.fn['vsnip#available'](1) == 1 then
                -- edit here --
		vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
                 return ''
	else
		return t('<Tab>')
	end
end

_G.s_tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t('<C-p>')
	elseif vim.fn['vsnip#jumpable'](-1) == 1 then
               -- edit here --
		vim.fn.feedkeys(t('<Plug>(vsnip-jump-prev)'), '')
                 return ''
	else
		-- If <S-Tab> is not working in your terminal, change it to <C-h>
		return t('<S-Tab>')
	end
end

vim.keymap.set({'i', 'v'}, '<Tab>', _G.tab_complete, {expr = true})
vim.keymap.set({'i', 'v'}, '<S-Tab>', _G.s_tab_complete, {expr = true})
