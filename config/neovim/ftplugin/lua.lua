vim.keymap.set("n", "<leader>xx", function ()
  vim.cmd.write()
  vim.cmd "source %"
end, {})

