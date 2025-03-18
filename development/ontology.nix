{ inputs, lib, config, pkgs, ... }:
with lib;
let
  cfg = config.development.ontology;
  # TODO: npm packaging is horribly annoying here
  /*
  stardog_repo = pkgs.fetchFromGitHub {
    owner = "stardog-union";
    repo = "stardog-language-servers";
    rev = "ea9f630d5dca126fc1b9fa31e3ee243dd5272f27";
    sha256 = "sha256-cj4BOu39Yyv/hJocnfcsVhmfdReU9e5dCS0HRt9/yhI=";
  };

  turtle_ls = pkgs.buildNpmPackage {
    pname = "turtle_ls";
    version = "0.0.1";
    npmDepsHash = "sha256-x8FBFkT2zdy4Tj8Zg+nnoV1Xw5WGpabjUL/3Tq06tAA=";

    src = stardog_repo;
    buildInputs = [ 
      pkgs.nodejs
    ];

    postUnpack = ''
      npm install --package-lock-only
    '';

    postPatch = ''
      cd packages/turtle-language-server
    '';
  };
  */

in {

  options.development.ontology = {
    enable = mkEnableOption "Enable development of ontologies";
  };

  config = mkIf cfg.enable {

    neovim-lsps.lsp-setups = {
      turtle_ls = builtins.readFile (./config/neovim/lsp/turtle_ls.lua);
    };

    programs.neovim.plugins = with pkgs.vimPlugins; [
      nvim-treesitter-parsers.turtle
      nvim-treesitter-parsers.sparql
    ];

    home.packages = with pkgs; [ 
      protege 
      # turtle_ls 
    ];
  };
}
