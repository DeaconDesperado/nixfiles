require('spectre').setup({
  open_cmd = '22new',
  live_update = true,
  replace_engine = {
    ['sed'] = {
      cmd = "sed",
      args = nil,
      options = {
        ['ignore-case'] = {
          value = "--ignore-case",
          icon = "[I]",
          desc = "ignore case"
        },
      }
    }
  },
  default = {
    replace = {
      cmd = "sed",
    }
  },
  is_block_ui_break = true
})

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre"
})
