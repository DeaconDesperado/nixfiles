require('lspconfig').pyright.setup {
  capabilities = require('blink.cmp').get_lsp_capabilities()
}
