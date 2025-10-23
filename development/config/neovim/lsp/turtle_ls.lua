vim.lsp.config("turtle_ls", {
  capabilities = require('blink.cmp').get_lsp_capabilities()
})
vim.lsp.enable({"turtle_ls"})
