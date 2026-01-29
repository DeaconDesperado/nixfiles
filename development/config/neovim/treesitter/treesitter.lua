-- Treesitter Plugin Setup (nvim-treesitter 1.0+)
-- Parsers are pre-installed via Nix using withPlugins

-- Start treesitter highlighting for buffers with available parsers
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft
    local ok = pcall(vim.treesitter.start, args.buf, lang)
    if not ok then
      -- Parser not available for this filetype, fall back to syntax
      vim.bo[args.buf].syntax = 'ON'
    end
  end,
})

-- Treesitter-based folding (disabled by default)
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = false
