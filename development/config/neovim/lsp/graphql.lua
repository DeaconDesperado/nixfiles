require('lspconfig').graphql.setup {
  filetypes = {"graphql", "graphqls"},
  root_dir = require('lspconfig').util.root_pattern(".graphqlconfig", ".graphqlrc"),
}
