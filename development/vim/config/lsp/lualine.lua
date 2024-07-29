local navic = require("nvim-navic")
navic.setup({
  lsp = {
    auto_attach = true
  }
})

local function navicline()
  if navic.is_available() then
      return navic.get_location({
        separator = "  ",
      })
    end
end

require('lualine').setup{
  options = {
    theme = 'auto',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', {navicline}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}
