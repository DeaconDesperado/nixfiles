vim.lsp.config("pyright", {
  capabilities = require('blink.cmp').get_lsp_capabilities()
})
vim.lsp.enable({"pyright"})
