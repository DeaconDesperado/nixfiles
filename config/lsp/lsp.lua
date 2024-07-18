require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason_lspconfig.setup{ ensure_installed = {
  "lua_ls",
  "jdtls",
  "pyright",
  "kotlin_language_server",
  "graphql"
  }
}

mason_lspconfig.setup_handlers {
  ['rust_analyzer'] = function() end,
}

lspconfig.pyright.setup {}

lspconfig.kotlin_language_server.setup{
  filetypes = {"kotlin", "kt"}
}

lspconfig.lua_ls.setup {
  filetypes = {"lua"}
}

lspconfig.graphql.setup {
  filetypes = {"graphql", "graphqls"},
  root_dir = lspconfig.util.root_pattern(".graphqlconfig", ".graphqlrc"),
}

-- LSP mappings
vim.keymap.set("n", "gd",  "<C-W><C-]><C-W>T")
vim.keymap.set("n", "K",  vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gds", vim.lsp.buf.document_symbol)
vim.keymap.set("n", "gws", vim.lsp.buf.workspace_symbol)
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run)
vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
