{ config, pkgs, lib, ... }:

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
  home.stateVersion = "22.11";

  home.file = {
    bqj = {
      executable = true;
      source = lib.cleanSource ./scripts/bqj; 
      target = "./scripts/bqj";
    };
  };

  home.sessionPath = [
    "$HOME/scripts"
  ];

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      withNodeJs = true;
      extraConfig = ''
        set nobackup
        set ts=2
        set sw=2
        set et
        colorscheme kanagawa-wave
      '';
      plugins = with pkgs.vimPlugins; [
        nvchad
        nvchad-ui
        kanagawa-nvim
        { 
          plugin = mason-nvim;
        }
        mason-lspconfig-nvim
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
          require("mason").setup()
          require("mason-lspconfig").setup{ ensure_installed = {"lua_ls", "rust_analyzer"}}
          '';
        }
        plenary-nvim
        nvim-dap
        {
          plugin = rust-tools-nvim;
          type = "lua";
          config = builtins.readFile(./config/rust-tools/rust-tools.lua);
        }
        vim-thrift
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
        side-by-side = true;
        syntax-theme = "Nord"; 
      };
    };

    tmux = {
      enable = true;
      terminal = "xterm-256color";
      baseIndex = 1;
      keyMode = "vi";
      shortcut = "s";
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins "cpu-usage ram-usage"
            set -g @dracula-show-battery false
            set -g @dracula-show-powerline true
            set -g @dracula-refresh-rate 10
            # set -g @dracula-show-left-icon window
          '';
        }
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
      enableAutosuggestions = false;
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

    alacritty.enable = true;

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
      enableAliases = true;
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
      fx
      krew
      marksman
      emacs
      httpie
      obsidian
      d2
      cloud-sql-proxy
      k9s
      pluto
      nodePackages.dockerfile-language-server-nodejs
      ltex-ls
      languagetool
      rnix-lsp
      jdt-language-server
      texlab
      editorconfig-checker
      hugo
      colima
      act
      avro-tools
      pqrs
      bazel_5
      bazel-buildtools
      cargo-generate
      coreutils
      curl
      delta
      deno
      discord
      ditaa
      duf
      html-tidy
      gdb
      gettext
      gh
      gitAndTools.hub
      gnupg
      gnused
      go
      (google-cloud-sdk.withExtraComponents
        ([ google-cloud-sdk.components.gke-gcloud-auth-plugin ]))
      gopls
      gradle
      graphviz-nox
      imagemagick
      jq
      keymapviz
      kind
      kubebuilder
      kubectx
      kubernetes
      kubernetes-helm
      kustomize
      leiningen
      maven
      metals
      minikube
      moreutils
      mosh
      nixfmt
      nixpkgs-fmt
      nodePackages.generator-code
      nodePackages.mermaid-cli
      nodePackages.prettier
      nodePackages.sql-formatter
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yarn
      nodePackages.yo
      nodePackages.pyright
      nodePackages_latest.bash-language-server
      nodePackages_latest.markdownlint-cli
      nodejs_20
      operator-sdk
      pandoc
      protobuf
      (python3.withPackages
        (ps: with ps; with python3Packages; [
          pip
          readline
          sqlparse
          python-lsp-server
        ]))
      ripgrep
      rustup
      scala
      scala-cli
      scalafmt
      shellcheck
      silver-searcher
      tldr
      trino-cli
      watch
      wget
      yarn2nix
      yq-go
      zsh-completions
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ];

}
