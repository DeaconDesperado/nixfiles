require('qluels').setup({
  server = {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    on_attach = function(client, bufnr)
       vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = bufnr, desc = 'LSP: ' .. '[F]ormat' })
       vim.keymap.set('n', '<leader>ex', ':QluelsExecute<cr>', { buffer = bufnr, desc = 'Execute SPARQL buffer' })
       vim.keymap.set('n', '<leader>ev', ':<,\'>QluelsExecuteSelection<cr>', { buffer = bufnr, desc = 'Execute SPARQL selection' })
       vim.keymap.set('n', '<leader>qb', ':QluelsSetBackend<cr>', { buffer = bufnr, desc = 'Set QlueLs backend' })
    end,
  },
  auto_attach = true
})
