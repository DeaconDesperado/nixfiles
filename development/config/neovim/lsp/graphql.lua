vim.lsp.config("graphql", {
  filetypes = { "graphql", "graphqls" },
  root_dir = vim.fs.root(0, {".graphqlconfig", ".graphqlrc"}),
  capabilities = require('blink.cmp').get_lsp_capabilities()
})
vim.lsp.enable({"graphql"})
