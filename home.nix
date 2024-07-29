{ config, pkgs, lib, outputs, ... }: {
  
  imports = [
    ./vim
  ];

  home.stateVersion = "24.05";

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

    htop.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
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
        lfs.lockverify = false;
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
        bazel = "bazelisk";
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
      dbt
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
      graphqurl
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
      nurl
      pyright
      nodejs_20
      operator-sdk
      pandoc
      pluto
      postgresql_16
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
      watchexec
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
