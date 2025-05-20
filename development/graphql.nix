{ inputs, lib, config, pkgs, ... }:
with lib;
let cfg = config.development.graphql;
in {

  options.development.graphql = {
    enable = mkEnableOption "Enable graphql development";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ graphqurl ];

    development.shellFunctions =
      builtins.readFile (./config/graphql/gql-fml.sh);

    # Configured via ftplugin below
    neovim-lsps.lsp-setups = {
      graphql = builtins.readFile (./config/neovim/lsp/graphql.lua);
    };
  };
}
