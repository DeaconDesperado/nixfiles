vim.api.nvim_create_user_command('LoadCopilot', function(input)
  vim.cmd.packadd({args = {"copilot.lua"} });
  vim.cmd.packadd({args = {"CopilotChat.nvim"} });
  require('copilot').setup({});
  require('CopilotChat').setup({});
end, {})
