{ inputs, lib, config, pkgs, ... }:
with lib;
let cfg = config.development.jvm;
in {

  options.development.jvm = {
    enable = mkEnableOption "Enable JVM development";
    mavenRepositories = mkOption {
      type = types.listOf
        (types.either (types.enum [ "local" "maven-central" "maven-local" ])
          (types.attrsOf types.str));
      default = [ "local" "maven-central" ];
    };
  };

  config = mkIf cfg.enable {
    programs.sbt = {
      enable = true;
      repositories = cfg.mavenRepositories;
    };

    neovim-treesitter.grammars = [ "java" "kotlin" "scala" ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      nvim-jdtls
      {
        plugin = nvim-metals;
        type = "lua";
        config = builtins.readFile (./config/neovim/lsp/metals.lua);
      }
    ];

    programs.zsh.shellAliases = { coursier = "cs"; };

    home.packages = with pkgs; [
      bloop
      coursier
      gradle
      jdt-language-server
      leiningen
      maven
      metals
      scala
      scala-cli
      scalafmt
    ];

    # Configured via ftplugin below
    neovim-lsps.lsp-setups = { jdtls = ""; };

    home.file = {
      "java.lua" = {
        source = lib.cleanSource ./config/neovim/lsp/jdtls.lua;
        target = ".config/nvim/after/ftplugin/java.lua";
      };

      ".ideavimrc" = {
        source = lib.cleanSource ./config/neovim/ideavimrc;
        target = ".ideavimrc";
      };
    };
  };

}
