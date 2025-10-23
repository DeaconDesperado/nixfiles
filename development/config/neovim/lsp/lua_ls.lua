vim.lsp.config("lua_ls", {
  filetypes = { "lua" },
  capabilities = require('blink.cmp').get_lsp_capabilities()
})
vim.lsp.enable({"lua_ls"})
