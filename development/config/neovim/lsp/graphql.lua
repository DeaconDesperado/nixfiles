require('lspconfig').graphql.setup {
  filetypes = { "graphql", "graphqls" },
  root_dir = require('lspconfig').util.root_pattern(".graphqlconfig", ".graphqlrc"),
  capabilities = require('blink.cmp').get_lsp_capabilities()
}
