{ inputs, lib, config, pkgs, outputs, ... }:

let
  vim-thrift = pkgs.vimUtils.buildVimPlugin {
    name = "vim-thrift";
    src = pkgs.fetchFromGitHub {
      owner = "solarnz";
      repo = "thrift.vim";
      rev = "f627aace1e583aed42f12d2a48b40fc18449a145";
      sha256 = "JccjaGkxZyuWBs7rVzGUxNQ6tTpHUhg7vNtSK2o3EwI=";
    };
  };

  lazydev-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lazydev-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "lazydev.nvim";
      rev = "v1.7.0";
      hash = "sha256-th/wfvKGsEpkKau0DUhUpFc4WMMhSDZ/ISEHxH0IQ48=";
    };
  };

in {
  nixpkgs.overlays = [ outputs.pkgs-unstable outputs.neovim-nightly.overlay ];

  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
    coc = { enable = false; };
    withNodeJs = true;
    extraConfig = ''
      filetype on
      filetype plugin on
      set nobackup
      set noswapfile
      set nowritebackup
      set ts=2
      set sw=2
      set et
      set termguicolors
      colorscheme kanagawa-wave
      set number
      :set rtp+=~/projects/foss/mgii/nvim-dipath
    '';
    plugins = with pkgs.vimPlugins; [
      kanagawa-nvim
      mason-nvim
      mason-lspconfig-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile (./config/lsp/lsp.lua);
      }
      plenary-nvim
      {
        plugin = fidget-nvim;
        type = "lua";
        config = builtins.readFile (./config/lsp/fidget.lua);
      }
      nvim-dap
      {
        plugin = rustaceanvim;
        type = "lua";
        config = builtins.readFile (./config/rust-tools/rust-tools.lua);
      }
      nvim-jdtls
      {
        plugin = nvim-metals;
        type = "lua";
        config = builtins.readFile (./config/lsp/metals.lua);
      }
      vim-thrift
      {
        plugin = nvim-treesitter;
        type = "lua";
        config = builtins.readFile (./config/treesitter/treesitter.lua);
      }
      {
        plugin = typescript-tools-nvim;
        type = "lua";
        config = builtins.readFile (./config/lsp/typescript.lua);
      }
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.java
      nvim-treesitter-parsers.javascript
      nvim-treesitter-parsers.lua
      nvim-treesitter-parsers.yaml
      nvim-treesitter-parsers.json
      nvim-treesitter-parsers.kotlin
      nvim-treesitter-parsers.scala
      nvim-treesitter-parsers.python
      nvim-ts-autotag
      nvim-web-devicons
      {
        plugin = trouble-nvim;
        type = "lua";
        config = builtins.readFile (./config/trouble/trouble.lua);
      }
      {
        plugin = rust-vim;
        config = builtins.readFile (./config/rust/rust-lang.viml);
      }
      nvim-cmp
      {
        plugin = cmp-nvim-lsp;
        type = "lua";
        config = builtins.readFile (./config/lsp/completions.lua);
      }
      cmp-path
      cmp-buffer
      cmp-vsnip
      vim-vsnip
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile (./config/neovim/telescope.lua);
      }
      vim-bookmarks
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      telescope-file-browser-nvim
      telescope-vim-bookmarks-nvim
      nvim-navic
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile (./config/lsp/lualine.lua);
      }
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = builtins.readFile (./config/neovim/colorizer.lua);
      }
      {
        plugin = nvim-spectre;
        type = "lua";
        config = builtins.readFile (./config/neovim/spectre.lua);
      }
      {
        plugin = todo-comments-nvim;
        type = "lua";
        config = builtins.readFile (./config/neovim/todo-comments.lua);
      }
      {
        plugin = lazydev-nvim;
        type = "lua";
        config = builtins.readFile (./config/neovim/lazydev-nvim.lua);
      }
    ];
  };

  home.file = {
    "java.lua" = {
      source = lib.cleanSource ./config/lsp/jdtls.lua;
      target = ".config/nvim/after/ftplugin/java.lua";
    };

    "lua.lua" = {
      source = lib.cleanSource ./config/neovim/ftplugin/lua.lua;
      target = ".config/nvim/after/ftplugin/lua.lua";
    };
  };
}
