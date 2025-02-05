require('lspconfig').roc_ls.setup {
  capabilities = require('blink.cmp').get_lsp_capabilities()
}
