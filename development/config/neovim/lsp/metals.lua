vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

-- buffer diagnostics only
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist)

vim.keymap.set("n", "<leader>ws", function()
  require("metals").hover_worksheet()
end)

-- all workspace diagnostics
vim.keymap.set("n", "<leader>aa", vim.diagnostic.setqflist)

-- all workspace errors
vim.keymap.set("n", "<leader>ae", function()
  vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
end)

-- all workspace warnings
vim.keymap.set("n", "<leader>aw", function()
  vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN })
end)

vim.keymap.set("n", "[c", function()
  vim.diagnostic.jump({ count = 1, float = true })
end)

vim.keymap.set("n", "]c", function()
  vim.diagnostic.jump({ count = -1, float = true })
end)

-- Example mappings for usage with nvim-dap. If you don't use that, you can
-- skip these
vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end)

vim.keymap.set("n", "<leader>dr", function()
  require("dap").repl.toggle()
end)

vim.keymap.set("n", "<leader>dK", function()
  require("dap.ui.widgets").hover()
end)

vim.keymap.set("n", "<leader>dt", function()
  require("dap").toggle_breakpoint()
end)

vim.keymap.set("n", "<leader>dso", function()
  require("dap").step_over()
end)

vim.keymap.set("n", "<leader>dsi", function()
  require("dap").step_into()
end)

vim.keymap.set("n", "<leader>dl", function()
  require("dap").run_last()
end)

-- completion related settings
-- This is similiar to what I use

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  useGlobalExecutable = true,
}

local function metals_status_handler(_, status, ctx)
  -- https://github.com/scalameta/nvim-metals/blob/main/lua/metals/status.lua#L36-L50
  local val = {}
  if status.hide then
    val = { kind = "end" }
  elseif status.show then
    val = { kind = "begin", message = status.text }
  elseif status.text then
    val = { kind = "report", message = status.text }
  else
    return
  end
  local info = { client_id = ctx.client_id }
  local msg = { token = "metals", value = val }
  -- call fidget progress handler
  vim.lsp.handlers["$/progress"](nil, msg, info)
end


metals_config.init_options.statusBarProvider = "on"
require("metals.handlers")["metals/status"] = metals_status_handler

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
metals_config.capabilities = require("blink-cmp").get_lsp_capabilities()

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autovim.cmd.
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
