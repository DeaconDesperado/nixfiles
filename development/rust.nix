{ lib, config, pkgs, ... }:
let cfg = config.development.qmk;
in {
  options = {
    development.rust.enable = lib.mkEnableOption "Enable Rust development";
  };

  config = lib.mkIf cfg.enable {

    neovim-treesitter.grammars = [ "rust" ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = rustaceanvim;
        type = "lua";
        config = builtins.readFile (./config/neovim/rust-tools/rust-tools.lua);
      }
      {
        plugin = rust-vim;
        config = builtins.readFile (./config/neovim/rust/rust-lang.viml);
      }
    ];

    #config contents
    home.packages = with pkgs; [ cargo-generate rustup wasm-pack ];
  };
}
