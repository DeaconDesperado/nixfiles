{ lib, config, pkgs, ... }:
let cfg = config.development.qmk;
in {
  options = {
    development.qmk.enable = lib.mkEnableOption "Enable Rust development";
  };

  config = lib.mkIf cfg.enable {

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = rustaceanvim;
        type = "lua";
        config = builtins.readFile (./config/neovim/rust-tools/rust-tools.lua);
      }
      nvim-treesitter-parsers.rust
      {
        plugin = rust-vim;
        config = builtins.readFile (./config/neovim/rust/rust-lang.viml);
      }
    ];

    #config contents
    home.packages = with pkgs; [ cargo-generate rustup ];
  };
}
