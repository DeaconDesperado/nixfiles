{ inputs, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.development.ontology;

  qlue-ls = pkgs.rustPlatform.buildRustPackage rec {
    pname = "qlue-ls";
    version = "0.19.2";

    src = inputs.qlue_ls;
    # Build only the binary, not the WASM library
    cargoBuildFlags = [ "--bin" "qlue-ls" ];
    builtType = "debug";
    cargoLock.lockFile = "${inputs.qlue_ls}/Cargo.lock";
  };
in {

  options.development.ontology = {
    enable = mkEnableOption "Enable development of ontologies";
  };

  config = mkIf cfg.enable {

    neovim-lsps.lsp-setups = {
      qlue_ls = builtins.readFile (./config/neovim/lsp/qlue_ls.lua);
    };

    home.file = {
      "qlue-ls.toml" = {
        source = cleanSource ./config/qlue-ls/qlue-ls.toml;
        target = ".config/qlue-ls/qlus-ls.toml";
      };
    };

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-treesitter-parsers.turtle;
        type = "lua";
        config = ''
          vim.treesitter.language.register('turtle', { 'ttl', 'r2rml', 'obda' })
        '';
      }
      nvim-treesitter-parsers.sparql
    ];

    home.packages = with pkgs; [
      protege
      apache-jena
      qlue-ls
      # turtle_ls
    ];
  };
}
