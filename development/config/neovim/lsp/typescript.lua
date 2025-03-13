require('typescript-tools').setup {
  settings = {
    expose_as_code_action = { "add_missing_imports", "remove_unused_imports", "organize_imports" },
    jsx_close_tag = {
      enable = true,
      filetypes = { "javascriptreact", "typescriptreact" },
    }
  },
  capabilities = require('blink.cmp').get_lsp_capabilities(),
}
