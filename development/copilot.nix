{ inputs, lib, config, pkgs, outputs, ... }:
with lib;
let cfg = config.development.copilot;
in {
  options.development.copilot = {
    enable = mkEnableOption "Enable copilot and it's plugins";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ luajitPackages.tiktoken_core ];

    programs.neovim.plugins = with pkgs; [
      {
        plugin = vimPlugins.copilot-lua;
        type = "lua";
      }
      {
        plugin = inputs.mcphub-nvim.packages."${pkgs.system}".default;
        type = "lua";
      }
      {
        plugin = vimPlugins.codecompanion-nvim;
        type = "lua";
        config = builtins.readFile (./config/neovim/copilot/copilot-chat.lua);
      }
    ];
  };
}

