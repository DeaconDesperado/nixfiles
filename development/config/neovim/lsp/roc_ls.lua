vim.lsp.config("roc_ls", {
  cmd = { "roc", "experimental-lsp" },
  filetypes = { "roc" },
  root_markers = { "main.roc", "app.roc" },
  capabilities = require('blink.cmp').get_lsp_capabilities()
})
vim.lsp.enable({"roc_ls"})
