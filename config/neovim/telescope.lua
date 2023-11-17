
local open_in_new_tab = {
  i = {
    ["<CR>"] = "select_tab"
  },
  n = {
    ["<CR>"] = "select_tab"
  }
}

require('telescope').setup {
  defaults = {
    mappings = open_in_new_tab,
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    },
    file_browser = {
      hijack_netrw = true,
    }
  }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', ":Telescope vim_bookmarks<CR>", { noremap = true })
vim.keymap.set('n', '<leader>fbr', ":Telescope file_browser<CR>", { noremap = true })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})
vim.keymap.set('n', '<leader>flr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fld', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>fli', builtin.lsp_implementations, {})

require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("vim_bookmarks")
