local rt = require("rust-tools")

rt.setup({
  tools = {
    inlay_hints = {
      only_current_line = false,
    },
  },
  server = {
    settings = {
      ["rust-analyzer"] = {
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
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>rr", rt.runnables.runnables, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
