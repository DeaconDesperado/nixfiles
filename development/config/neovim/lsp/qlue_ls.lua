vim.lsp.config ("qlue-ls", {
  name = 'qlue-ls',
  filetypes = {'sparql'},
  cmd = { 'qlue-ls', 'server' },
  cmd_env = {
    RUST_BACKTRACE = 1
  },
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  root_dir = vim.fn.getcwd(),
  on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = bufnr, desc = 'LSP: ' .. '[F]ormat' })
  end,
})

vim.lsp.enable({'qlue-ls'})
