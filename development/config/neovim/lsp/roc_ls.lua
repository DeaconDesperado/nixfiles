vim.lsp.config("roc_ls", {
  capabilities = require('blink.cmp').get_lsp_capabilities()
})
vim.lsp.enable({"roc_ls"})
