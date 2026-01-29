{ inputs, lib, config, pkgs, ... }:
with lib;
let cfg = config.development.python;
in {

  options.development.python = {
    enable = mkEnableOption "Enable Python development";
  };

  config = mkIf cfg.enable {

    neovim-lsps.lsp-setups = {
      pyright = builtins.readFile (./config/neovim/lsp/pyright.lua);
    };

    neovim-treesitter.grammars = [ "python" ];

    programs.zsh.plugins = [{
      name = "zsh-pyenv";
      src = pkgs.fetchFromGitHub {
        owner = "mattberther";
        repo = "zsh-pyenv";
        rev = "56a3081dbe345a635b12095914b234cb11a350a0";
        sha256 = "1ksa1bbhnlmrk9n7jnq85s2vpc50qm8g5jqgqzixvjdjyw9y1n2n";
      };
    }];

    home.packages = with pkgs; [
      (python3.withPackages (ps:
        with ps; [
          pip
          readline
          sqlparse
          pudb
          python-lsp-server
          pylatexenc
        ]))
      poetry
      pyright
      uv
    ];
  };

}
