require("mason").setup()
require("mason-lspconfig").setup{ ensure_installed = {"lua_ls", "rust_analyzer", "jdtls", "pyright"}}

require("lspconfig").pyright.setup {}
