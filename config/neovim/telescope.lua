local actions = require("telescope.actions")

local open_in_new_tab = {
  i = {
    ["<CR>"] = "select_tab_drop",
  },
  n = {
    ["<CR>"] = "select_tab_drop",
  }
}

local zellij_remap = {
  i = {
    ["<M-q>"] = actions.smart_send_to_qflist + actions.open_qflist, 
    ["<M-t>"] = "select_tab_drop",
  },
  n = {
    ["<M-q>"] = actions.smart_send_to_qflist + actions.open_qflist, 
    ["<M-t>"] = "select_tab_drop",
  }
}

require('telescope').setup {
  defaults = {
    mappings = zellij_remap,
    file_ignore_patterns = {
      "target/",
      "project/target/",
    }
  },
  pickers = {
    lsp_references = {
			jump_type = "never",
			show_line = false,
      mappings = open_in_new_tab,
		},
		lsp_implementations = {
			jump_type = "never",
			reuse_win = true,
			show_line = false,
      mappings = open_in_new_tab,
		},
		lsp_definitions = {
			jump_type = "never",
			reuse_win = true,
			show_line = false,
      mappings = open_in_new_tab,
		},    
    find_files = {
      mappings = open_in_new_tab,
    },
    live_grep = {
      mappings = open_in_new_tab,
    },
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
    },
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

vim.keymap.set('n', '<leader>j', ':cn<CR>')
vim.keymap.set('n', '<leader>k', ':cp<CR>')

-- TODO: this doesn't actually reassign default, figure out why
require('telescope').extensions.vim_bookmarks.all = {    
  attach_mappings = function(_, map)
    map('n', '<CR>', function(prompt_bufnr)
      actions.select_tab_drop(prompt_bufnr)
    end);
    return false;
  end
}

