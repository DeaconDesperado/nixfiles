require('copilot').setup({
  panel = {
    auto_refresh = true;
  }
});
require('mcphub').setup();
require("codecompanion").setup({
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_vars = true,
        make_slash_commands = true,
        show_result_in_chat = true
      }
    }
  }
});
