vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}

require('blink-cmp').setup({
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "lazydev" },
    providers = {
      -- dont show LuaLS require statements when lazydev has items
      lsp = {
        name = 'LSP',
        module = 'blink.cmp.sources.lsp',
        fallbacks = { "lazydev" }
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink"
      },
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
      selection = { preselect = true, auto_insert = true}
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    }
   }
})

