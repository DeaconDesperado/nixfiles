{ inputs, lib, config, pkgs, ... }:
with lib;
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

  eldritch-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "eldritch-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "eldritch-theme";
      repo = "eldritch.nvim";
      rev = "48788ef2f7be7e86b0a57ef87f1a96bc18e24b8b";
      hash = "sha256-ShjgOkzE4h5zLsM9kSXePXgZossgwV2HW4Axq5y9cP4=";
    };
  };

  render-markdown-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "render-markdown-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "MeanderingProgrammer";
      repo = "render-markdown.nvim";
      rev = "v7.4.0";
      hash = "sha256-K2YbO4vIjVgYrWF4MVxqiaTmONF1ZvMXxZVIW/UYwRo=";
    };
  };

  colortils-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "colortils-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "DeaconDesperado";
      repo = "colortils.nvim";
      rev = "fb106df442a44854f8c15832256b750108bf7089";
      hash = "sha256-OBUcfIjT2PS5YRmNLr5kTT8yOoD/pCXL9NZFhkdRx+I=";
    };
  };

  cfg = config.neovim-lsps;

in {

  options.neovim-lsps = {
    lsp-setups = mkOption { type = types.attrsOf types.lines; };
  };

  config = {

    # Enable Lua by default for neovim plugin development
    neovim-lsps.lsp-setups = {
      lua_ls = builtins.readFile (./config/neovim/lsp/lua_ls.lua);
    };

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
        set nomodeline
        set nobackup
        set noswapfile
        set nowritebackup
        set ts=2
        set sw=2
        set et
        set termguicolors
        colorscheme kanagawa-wave
        set number
        set splitbelow
        set updatetime=1600
        :set rtp+=~/projects/foss/mgii/nvim-dipath
      '';
      plugins = with pkgs.vimPlugins; [
        kanagawa-nvim
        eldritch-nvim
        {
          plugin = mason-nvim;
          type = "lua";
          config = ''

            require("mason").setup()
          '';
        }
        {
          plugin = mason-lspconfig-nvim;
          type = "lua";
          config = let
            lspServerNames = lib.foldl' (a: b:
              a + b + ''
                ,
              '') "" (attrNames cfg.lsp-setups);
          in ''
            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup { 
              ensure_installed = { 
                  ${lspServerNames}
                },
                automatic_enable = {
                  exclude = {
                    "rust_analyzer"
                  }
               }
            }

          '';
        }
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = let
            hoverDiagnostics =
              builtins.readFile (./config/neovim/lsp/diagnostics.lua);
            lspSetups =
              lib.foldl' (a: b: a + b + "\n") "" (attrValues cfg.lsp-setups);
          in ''

            ${hoverDiagnostics}

            ${lspSetups}

            -- LSP mappings
            vim.keymap.set("n", "gd",  "<C-W><C-]><C-W>T")
            vim.keymap.set("n", "K",  vim.lsp.buf.hover)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
            vim.keymap.set("n", "gr", vim.lsp.buf.references)
            vim.keymap.set("n", "gds", vim.lsp.buf.document_symbol)
            vim.keymap.set("n", "gws", vim.lsp.buf.workspace_symbol)
            vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run)
            vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
          '';
        }
        plenary-nvim
        {
          plugin = fidget-nvim;
          type = "lua";
          config = builtins.readFile (./config/neovim/lsp/fidget.lua);
        }
        nvim-dap
        vim-thrift
        {
          plugin = nvim-treesitter;
          type = "lua";
          config =
            builtins.readFile (./config/neovim/treesitter/treesitter.lua);
        }
        {
          plugin = typescript-tools-nvim;
          type = "lua";
          config = builtins.readFile (./config/neovim/lsp/typescript.lua);
        }
        nvim-treesitter-parsers.javascript
        nvim-treesitter-parsers.lua
        nvim-treesitter-parsers.yaml
        nvim-treesitter-parsers.json
        nvim-treesitter-parsers.markdown
        nvim-ts-autotag
        nvim-web-devicons
        {
          plugin = trouble-nvim;
          type = "lua";
          config = builtins.readFile (./config/neovim/trouble/trouble.lua);
        }
        {
          plugin = blink-cmp;
          type = "lua";
          config = builtins.readFile (./config/neovim/lsp/completions.lua);
        }
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile (./config/neovim/neovim/telescope.lua);
        }
        vim-bookmarks
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        telescope-file-browser-nvim
        telescope-vim-bookmarks-nvim
        nvim-navic
        {
          plugin = diffview-nvim;
          type = "lua";
          config = builtins.readFile (./config/neovim/neovim/diffview.lua);
        }
        {
          plugin = lualine-nvim;
          type = "lua";
          config = builtins.readFile (./config/neovim/lsp/lualine.lua);
        }
        {
          plugin = colortils-nvim;
          type = "lua";
          config = builtins.readFile (./config/neovim/colortils/colortils.lua);
        }
        {
          plugin = nvim-colorizer-lua;
          type = "lua";
          config = builtins.readFile (./config/neovim/neovim/colorizer.lua);
        }
        {
          plugin = nvim-spectre;
          type = "lua";
          config = builtins.readFile (./config/neovim/neovim/spectre.lua);
        }
        {
          plugin = todo-comments-nvim;
          type = "lua";
          config = builtins.readFile (./config/neovim/neovim/todo-comments.lua);
        }
        {
          plugin = lazydev-nvim;
          type = "lua";
          config = builtins.readFile (./config/neovim/neovim/lazydev-nvim.lua);
        }
        {
          plugin = render-markdown-nvim;
          type = "lua";
          config =
            builtins.readFile (./config/neovim/neovim/render-markdown.lua);
        }
      ];
    };

    home.file = {
      "lua.lua" = {
        source = lib.cleanSource ./config/neovim/neovim/ftplugin/lua.lua;
        target = ".config/nvim/after/ftplugin/lua.lua";
      };

      "markdown.json" = {
        source = lib.cleanSource ./config/neovim/snippets/markdown.json;
        target = ".config/nvim/snippets/markdown.json";
      };
    };
  };
}
