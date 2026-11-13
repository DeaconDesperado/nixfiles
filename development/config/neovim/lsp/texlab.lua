vim.lsp.config("texlab", {
  capabilities = require('blink.cmp').get_lsp_capabilities()
})
vim.lsp.enable({"texlab"})
