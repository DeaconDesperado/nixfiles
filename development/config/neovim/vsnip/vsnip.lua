local function jump(direction, alias, key)
  if vim.fn["vsnip#jumpable"](direction) then
   vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(" .. alias .. ")", true, true, true))
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true))
  end
end

vim.keymap.set({'i', 'v'}, '<Tab>', function () jump(1, "vsnip-jump-next", "<Tab>") end)
vim.keymap.set({'i', 'v'}, '<S-Tab>', function () jump(1, "vsnip-jump-prev", "<S-Tab>") end)
