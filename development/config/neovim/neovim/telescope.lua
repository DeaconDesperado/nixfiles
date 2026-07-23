local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function open_selected_in_tabs(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selections = picker:get_multi_selection()
  actions.close(prompt_bufnr)
  for _, entry in ipairs(selections) do
    if entry.filename or entry.path then
      vim.cmd("tabedit " .. vim.fn.fnameescape(entry.filename or entry.path))
      if entry.lnum then
        vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col or 0 })
      end
    end
  end
end

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
    ["<M-CR>"] = open_selected_in_tabs,
    ["<C-Q>"] = false,
  },
  n = {
    ["<M-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
    ["<M-t>"] = "select_tab_drop",
    ["<M-CR>"] = open_selected_in_tabs,
    ["<C-Q>"] = false,
  }
}

require('telescope').setup {
  defaults = {
    mappings = zellij_remap,
    file_ignore_patterns = {
      "target/",
      "project/target/",
      ".git/",
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
      hidden = true,
    },
    live_grep = {
      mappings = open_in_new_tab,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
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
vim.keymap.set('n', '<leader>ftd', ":TodoTelescope <CR>", { noremap = true })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})
vim.keymap.set('n', '<leader>flr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fld', builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>fli', builtin.lsp_implementations, {})

require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("vim_bookmarks")

vim.keymap.set('n', '<leader>ej', ':cn<CR>')
vim.keymap.set('n', '<leader>ek', ':cp<CR>')

-- TODO: this doesn't actually reassign default, figure out why
require('telescope').extensions.vim_bookmarks.all = {
  attach_mappings = function(_, map)
    map('n', '<CR>', function(prompt_bufnr)
      actions.select_tab_drop(prompt_bufnr)
    end);
    return false;
  end
}
