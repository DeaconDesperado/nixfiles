local background_gen = function ()
  local hl = vim.api.nvim_get_hl(0, {
    name = 'FloatBorder',
  });
  return string.format("#%06x", hl.bg)
end

require("colortils").setup({
  background = background_gen(),
  mappings = {
    set_register_default_format = "<m-cr>",
    replace_default_format = "<cr>",
  };
});

vim.keymap.set("n", "<Leader>cpp", function ()
  vim.cmd("Colortils picker")
end, {})

vim.keymap.set("n", "<Leader>cj", function ()
  vim.cmd("Colortils darken")
end, {})


vim.keymap.set("n", "<Leader>ck", function ()
  vim.cmd("Colortils lighten")
end, {})
