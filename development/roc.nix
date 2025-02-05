{ inputs, lib, config, pkgs, ... }:
with lib;
let cfg = config.development.roc;
in {

  options.development.roc = {
    enable = mkEnableOption "Enable Roc development";
  };

  config = mkIf cfg.enable {

    neovim-lsps.lsp-setups = {
      roc_ls = builtins.readFile (./config/neovim/lsp/roc_ls.lua);
    };

    programs.neovim.plugins = with pkgs.vimPlugins;
      [ nvim-treesitter-parsers.roc ];

    home.packages = with pkgs; [
      inputs.roc.packages.${system}.cli
      inputs.roc.packages.${system}.lang-server
    ];
  };

}
