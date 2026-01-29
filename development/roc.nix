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

    neovim-treesitter.grammars = [ "roc" ];

    home.packages = with pkgs; [
      inputs.roc.packages.${pkgs.stdenv.hostPlatform.system}.cli
      inputs.roc.packages.${pkgs.stdenv.hostPlatform.system}.lang-server
    ];
  };

}
