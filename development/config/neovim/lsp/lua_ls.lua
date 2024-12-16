require('lspconfig').lua_ls.setup {
  filetypes = {"lua"},
  capabilities = require('blink.cmp').get_lsp_capabilities()
}
