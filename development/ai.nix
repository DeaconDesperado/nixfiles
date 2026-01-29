{ inputs, lib, config, pkgs, outputs, ... }:
with lib;
let cfg = config.development.ai;
in {
  options.development.ai = {
    enable = mkEnableOption "Enable ai-assist and plugins";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ luajitPackages.tiktoken_core claude-code ];

    programs.zsh.initContent = let
      claude_code_source = builtins.readFile (./config/claude-code/claude.zsh);
    in ''
      ${claude_code_source} 
    '';

    home.file = {
      claude-keybinds = {
        source = lib.cleanSource ./config/claude-code/keybindings.json;
        target = "./.claude/keybindings.json";
      };
    };

    programs.neovim.plugins = with pkgs; [
      {
        plugin = vimPlugins.copilot-lua;
        type = "lua";
      }
      {
        plugin = inputs.mcphub-nvim.packages."${pkgs.stdenv.hostPlatform.system}".default;
        type = "lua";
      }
      #{
      #  plugin = vimPlugins.codecompanion-nvim;
      #  type = "lua";
      #  config = builtins.readFile (./config/neovim/copilot/copilot-chat.lua);
      #}
    ];
  };
}

