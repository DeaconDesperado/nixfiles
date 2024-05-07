{ config, pkgs, lib, outputs, ... }:

let vim-thrift = pkgs.vimUtils.buildVimPlugin {
  name = "vim-thrift";
  src = pkgs.fetchFromGitHub {
    owner = "solarnz";
    repo = "thrift.vim";
    rev = "f627aace1e583aed42f12d2a48b40fc18449a145";
    sha256 = "JccjaGkxZyuWBs7rVzGUxNQ6tTpHUhg7vNtSK2o3EwI=";
  };
};

in {

  nixpkgs.overlays = [
    outputs.pkgs-unstable 
    outputs.neovim-nightly.overlay
  ];
  home.stateVersion = "23.11";

  home.file = {
    print_colors = {
      executable = true;
      source = lib.cleanSource ./scripts/print_colors; 
      target = "./scripts/print_colors";
    };
    
    bqj = {
      executable = true;
      source = lib.cleanSource ./scripts/bqj; 
      target = "./scripts/bqj";
    };

    "bytes.jq" = {
      executable = true;
      source = lib.cleanSource ./scripts/bytes.jq; 
      target = "./.jq/bytes.jq";
    };

    "config.kdl" = {
      source = lib.cleanSource ./config/zellij/config.kdl;
      target = ".config/zellij/config.kdl";
    };

    "layouts" = {
      source = lib.cleanSource ./config/zellij/layouts;
      target = ".config/zellij/layouts";
    };
    
    "java.lua" = {
      source = lib.cleanSource ./config/lsp/jdtls.lua; 
      target = ".config/nvim/after/ftplugin/java.lua";
    };

    "googlestyle.xml" = {
      source = lib.cleanSource ./config/codestyle/googlestyle.xml; 
      target = ".config/codestyle/googlestyle.xml";
    };

    "alacritty.toml" = {
      source = lib.cleanSource ./config/alacritty/alacritty.toml;
      target = ".config/alacritty/alacritty.toml";
    };
  };

  home.sessionPath = [
    "$HOME/scripts"
    "$HOME/bin"
    "$HOME/.cargo/bin"
  ];

  programs = {
    home-manager = {
      enable = true;
    };
    neovim = {
      package = pkgs.neovim-nightly;
      enable = true;
      viAlias = true;
      vimAlias = true;
      coc = {
        enable = false;
      };
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
      '';
      plugins = with pkgs.vimPlugins; [
        kanagawa-nvim
        mason-nvim
        mason-lspconfig-nvim
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = builtins.readFile(./config/lsp/lsp.lua);
        }
        plenary-nvim
        {
          plugin = fidget-nvim;
          type = "lua";
          config = builtins.readFile(./config/lsp/fidget.lua);
        }
        nvim-dap
        {
          plugin = rustaceanvim;
          type = "lua";
          config = builtins.readFile(./config/rust-tools/rust-tools.lua);
        }
        nvim-jdtls
        {
          plugin = nvim-metals;
          type = "lua";
          config = builtins.readFile(./config/lsp/metals.lua);
        }
        vim-thrift
        {
          plugin = nvim-treesitter;
          type = "lua";
          config = builtins.readFile(./config/treesitter/treesitter.lua);
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
          config = builtins.readFile(./config/trouble/trouble.lua);
        }
        {
          plugin = rust-vim;
          config = builtins.readFile(./config/rust/rust-lang.viml);
        }
        nvim-cmp
        {
          plugin = cmp-nvim-lsp;
          type = "lua";
          config = builtins.readFile(./config/lsp/completions.lua);
        }
        cmp-path
        cmp-buffer
        cmp-vsnip
        vim-vsnip
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile(./config/neovim/telescope.lua);
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
          config = builtins.readFile(./config/lsp/lualine.lua);
        }
        {
          plugin = nvim-colorizer-lua;
          type = "lua";
          config = builtins.readFile(./config/neovim/colorizer.lua);
        }
        {
          plugin = nvim-spectre;
          type = "lua";
          config = builtins.readFile(./config/neovim/spectre.lua);
        }
        {
          plugin = todo-comments-nvim;
          type = "lua";
          config = builtins.readFile(./config/neovim/todo-comments.lua);
        }
      ];
    };

    helix = {
      enable = true;
      settings = {
        theme = "rose_pine";
        editor = {
          line-number = "relative";
          mouse = true;
          lsp.display-messages = true;
          cursorline = true;
          indent-guides.render = true;
          color-modes = true;
        };
        keys.normal = { space.space = "file_picker"; };
        editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        editor.file-picker = { hidden = false; };
      };
      languages = { 
        language = [
          { name = "sql"; }
          { name = "latex"; }
          { name = "html"; }
          { name = "bash"; }
          { name = "toml"; }
          { name = "nix"; }
          { name = "markdown"; }
          { name = "yaml"; }
          { name = "dockerfile"; }
          {
            name = "json";
            formatter = {
              command = "prettier";
              args = [ "--parser" "json" ];
            };
          }
          { name = "go"; }
          { name = "java"; }
          {
            name = "scala";
            scope = "source.scala";
            roots = [ "build.sbt" "pom.xml" ];
            file-types = [ "scala" "sbt" ];
            comment-token = "//";
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            language-server = { command = "metals"; };
            config = { metals.ammoniteJvmProperties = [ "-Xmx1G" ]; };
          }
          { name = "rust"; }
          { name = "python"; }
          { name = "javascript"; }
          { name = "typescript"; }
        ];
      };
    };

    htop.enable = true;

    git = {
      enable = true;
      userName = "mgthesecond";
      userEmail = "mgthesecond@spotify.com";

      aliases = {
        s = "status";
        l =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };

      extraConfig = {
        core.editor = "vim";
        color.ui = true;
        branch.autosetuprebase = "always";
        pull.rebase = true;
        init.defaultBranch = "main";
        push.default = "tracking";
        hub.host = "ghe.spotify.net";
      };

      ignores = [ ".java_version" ".metals" "metals.sbt" ".bloop" ".idea" ".DS_Store" ".envrc" "shell.nix" ];

      delta.enable = true;
      delta.options = {
        kanagawa = {
          file-style                    = "cyan ul";
          file-decoration-style         = "blue ul";
          minus-style                   = "black red";
          minus-emph-style              = "ul black brightred";
          minus-empty-line-marker-style = "black red";
          line-numbers-minus-style      = "brightred black";
          zero-style                    = "blue";
          plus-style                    = "black green";
          plus-emph-style               = "ul black brightgreen";
          line-numbers-plus-style       = "brightgreen black";
          whitespace-error-style        = "auto auto";
          blame-code-style              = "auto auto";
          true-color                    = "auto";
          file-modified-label           = "changed";
          hyperlinks                    = "true";
          keep-plus-minus-markers       = "true";
          diff-stat-align-width         = "10";
          syntax-theme                  = "Nord";
        };
        features = "kanagawa";
        side-by-side = true;
      };
    };

    tmux = {
      enable = true;
      terminal = "tmux-256color";
      baseIndex = 1;
      keyMode = "vi";
      shortcut = "s";
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
      ];

      extraConfig = ''
        set -ga terminal-overrides ",xterm-256color*:Tc"
        set -g mouse on

        # act like vim
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R
        bind-key -r C-h select-window -t :-
        bind-key -r C-l select-window -t :+

        # set -g prefix2 C-s
        # renumber windows sequentially after closing any of them
        set -g renumber-windows on

        # prefix -> back-one-character
        bind-key C-b send-prefix
        # prefix-2 -> forward-incremental-history-search
        bind-key C-s send-prefix -2

        # don't suspend-client
        unbind-key C-z
      '';
    };

    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      syntaxHighlighting = { enable = true; };
      autosuggestion = { enable = false; };
      history.extended = true;
      shellAliases = {
        cat = "bat";
        git = "hub";
        k = "kubectl";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./config/p10k;
          file = "p10k.zsh";
        }
        {
          name = "zsh-pyenv";
          src = pkgs.fetchFromGitHub {
            owner = "mattberther";
            repo = "zsh-pyenv";
            rev = "56a3081dbe345a635b12095914b234cb11a350a0";
            sha256 = "1ksa1bbhnlmrk9n7jnq85s2vpc50qm8g5jqgqzixvjdjyw9y1n2n";
          };
        }
      ];
      initExtra = ''
        export USE_GKE_GCLOUD_AUTH_PLUGIN=True
        export LSP_USE_PLISTS=true
        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,bg=bold,underline"
        export PATH=$PATH:/opt/homebrew/bin:$HOME/go/bin
        export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
      '';
    };

    broot.enable = true;

    bat = {
      enable = true;
      config.theme = "Nord";
    };

    fzf.enable = true;
    fzf.historyWidgetOptions = [
      "--reverse"
    ];

    alacritty = {
      enable = true;
    };

    vscode = {
      enable = true;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

    eza = {
      enable = true;
    };

    zoxide.enable = true;

    sbt = {
      enable = true;
      repositories = [
        { artifactory = "https://artifactory.spotify.net/artifactory/repo"; }
        "local"
        "maven-central"
      ];
    };
  };

  home.packages = with pkgs;
    [
      # AWS
      unstable.awscli2
      # GCP
      google-cloud-sql-proxy
      (google-cloud-sdk.withExtraComponents
        ([ 
          google-cloud-sdk.components.gke-gcloud-auth-plugin 
          google-cloud-sdk.components.pubsub-emulator
        ]))
      # Python
      (python3.withPackages
        (ps: with ps; with python3Packages; [
          pip
          readline
          sqlparse
          python-lsp-server
        ]))
      act
      avro-tools
      bazelisk
      cargo-generate
      cmake
      colima
      coreutils
      coursier
      curl
      d2
      delta
      ditaa
      duf
      editorconfig-checker
      fd
      fx
      gdb
      gettext
      gh
      gitAndTools.hub
      gnupg
      gnused
      go
      gopls
      gradle
      graphviz-nox
      grpcurl
      html-tidy
      httpie
      hugo
      imagemagick
      jdt-language-server
      jq
      k9s
      keymapviz
      kind
      kotlin-language-server
      krew
      kubebuilder
      kubectx
      kubernetes
      kubernetes-helm
      kustomize
      languagetool
      leiningen
      ltex-ls
      lua
      marksman
      maven
      metals
      minikube
      moreutils
      mosh
      nixfmt-classic
      nixpkgs-fmt
      nodePackages.pyright
      nodejs_20
      operator-sdk
      pandoc
      pluto
      pqrs
      protobuf
      ripgrep
      rustup
      scala
      scala-cli
      scalafmt
      shellcheck
      silver-searcher
      texlab
      tldr
      trino-cli
      watch
      wget
      yarn
      yarn2nix
      yq-go
      zellij
      zsh-completions
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ];

}
