{ inputs, lib, config, pkgs, ... }:
with lib;
let cfg = config.development.cpp;
in {

  options.development.cpp = {
    enable = mkEnableOption "Enable C++ development";
  };

  config = mkIf cfg.enable {

    neovim-lsps.lsp-setups = {
      clangd = builtins.readFile (./config/neovim/lsp/clangd.lua);
    };

    neovim-treesitter.grammars = [ "cpp" ];

  };

}
