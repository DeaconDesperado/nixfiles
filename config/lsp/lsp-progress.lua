local lualine_kanagawa = require('lualine.themes.material')
local wave_colors = require("kanagawa.colors").setup({ theme = 'wave' })

-- Change the background of lualine_c section for normal mode
lualine_kanagawa.normal.c.bg = '#112233'


require('lualine').setup{
  options = {
    theme = 'auto',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', 'lsp_progress'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}
