vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}


require('blink-cmp').setup({
  sources = {
    cmdline = {}
  },
  appearance = {
    use_nvim_cmp_as_default = true,
  },
  keymap = {
     preset = 'enter',
     ['<S-Tab>'] = { 'select_prev', 'fallback' },
     ['<Tab>'] = { 'select_next', 'fallback' },
   },
   completion = {
    list = {
      selection = "manual",
    }
   }
})

