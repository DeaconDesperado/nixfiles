require('qluels').setup({
  server = {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    on_attach = function(client, bufnr)
       vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = bufnr, desc = 'LSP: ' .. '[F]ormat' })
       vim.keymap.set('n', '<leader>ex', ':QluelsExecuteQuery<cr>', { buffer = bufnr, desc = 'Execute SPARQL buffer' })
    end,
  },
  auto_attach = true
})
