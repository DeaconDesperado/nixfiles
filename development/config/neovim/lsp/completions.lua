vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}

require('blink-cmp').setup({
  sources = {
    cmdline = {},
    completion = {
      enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
    },
    providers = {
      -- dont show LuaLS require statements when lazydev has items
      lsp = { fallback_for = { "lazydev" } },
      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
    },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
  },
  keymap = {
     preset = 'enter',
     ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
     ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
   },
   completion = {
    list = {
      selection = "manual",
    }
   }
})

