require('lspconfig').clangd.setup {
  capabilities = require('blink.cmp').get_lsp_capabilities()
}
