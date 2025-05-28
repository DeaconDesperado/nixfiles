require('copilot').setup({
  panel = {
    auto_refresh = true;
  }
});
require('mcphub').setup();
require("codecompanion").setup({
  opts = {
    log_level = "TRACE",
  },
  display = {
    chat = {
      window = {
        layout = "horizontal",
        height = .45,
        full_height = false,
      }
    }
  },

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
