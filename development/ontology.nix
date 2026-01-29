{ inputs, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.development.ontology;

  qlue-ls = pkgs.rustPlatform.buildRustPackage rec {
    pname = "qlue-ls";
    version = "1.1.0";

    src = inputs.qlue_ls;
    # Build only the binary, not the WASM library
    cargoBuildFlags = [ "--bin" "qlue-ls" ];
    builtType = "debug";
    cargoLock.lockFile = "${inputs.qlue_ls}/Cargo.lock";
  };

  qlue-ls-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "qlue-ls-nvim";
    src = inputs.qlue_ls_nvim;
  };
in {

  options.development.ontology = {
    enable = mkEnableOption "Enable development of ontologies";
  };

  config = mkIf cfg.enable {

    home.file = {
      "qlue-ls.toml" = {
        source = cleanSource ./config/qlue-ls/qlue-ls.yml;
        target = ".config/qlue-ls/qlus-ls.yml";
      };
    };

    neovim-treesitter.grammars = [ "turtle" "sparql" ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = qlue-ls-nvim;
        type = "lua";
        config = ''
          vim.treesitter.language.register('turtle', { 'ttl', 'r2rml', 'obda' })
        '' + builtins.readFile (./config/neovim/lsp/qlue_ls.lua);
      }
    ];

    home.packages = with pkgs; [
      protege
      apache-jena
      qlue-ls
      # turtle_ls
    ];
  };
}
