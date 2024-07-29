vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        inlayHints = {
          parameterHints = {
            enable = false,
          },
          typeHints = {
            enable = false;
          }
        },
        check = {
          targets = {"aarch64-apple-darwin"},
        },
        cargo = {
          cfgs = {
            ci = "",
          },
        },
        procMacro = {
          enable = true,
        }
      },
    },
    on_attach = function(_, bufnr)
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      -- Hover actions
      vim.keymap.set("n", "<C-space>", function()
        vim.cmd.RustLsp { 'hover', 'actions' } end, opts)
      vim.keymap.set("n", "<Leader>rr", function()
        vim.cmd.RustLsp('runnables') end, opts)
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", function()
        vim.cmd.RustLsp('codeAction') end, opts)
    end,
  },
}
