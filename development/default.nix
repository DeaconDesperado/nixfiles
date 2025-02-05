{ inputs, lib, config, pkgs, outputs, ... }:
with lib;
let

  cfg = config.development;

  eldritch_repo = pkgs.fetchFromGitHub {
    owner = "eldritch-theme";
    repo = "btop";
    rev = "8d1546e8ff629e993dea56f626990b672f3ddf65";
    hash = "sha256-9cN85fmK2wjRrEpQn5tHw3h+q5ur/eBgtDBgYoY2Tgk=";
  };

in {

  imports = [
    ./vim.nix
    ./rust.nix
    ./jvm.nix
    ./gcloud.nix
    ./qmk.nix
    ./python.nix
    ./roc.nix
    ./graphql.nix
    ./copilot.nix
  ];

  options.development = {
    enable = mkEnableOption "Enable development environment";
    userName = mkOption {
      type = types.str;
      default = "mgthesecond";
    };
    userEmail = mkOption {
      type = types.str;
      default = "mgthesecond@spotify.com";
    };
    hubHost = mkOption {
      type = types.str;
      default = "ghe.spotify.net";
    };
  };

  config = mkIf cfg.enable {

    home.file = {
      eldritch_theme_btop = {
        source = "${eldritch_repo}/eldritch.theme";
        target = "./.config/btop/themes/eldritch.theme";
      };

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

      "googlestyle.xml" = {
        source = lib.cleanSource ./config/codestyle/googlestyle.xml;
        target = ".config/codestyle/googlestyle.xml";
      };

      "config.kdl" = {
        source = cleanSource ./config/zellij/config.kdl;
        target = ".config/zellij/config.kdl";
      };

      "layouts" = {
        source = cleanSource ./config/zellij/layouts;
        target = ".config/zellij/layouts";
      };

      "alacritty.toml" = {
        source = cleanSource ./config/alacritty/alacritty.toml;
        target = ".config/alacritty/alacritty.toml";
      };
    };

    programs.alacritty = { enable = true; };

    programs.btop = {
      enable = true;
      settings = { color_theme = "eldritch"; };
    };

    programs.zsh = {
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
        top = "btop";
        jless = "jless --mode line";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = cleanSource ./config/p10k;
          file = "p10k.zsh";
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

    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;

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
        merge.tool = "diffview";
        mergetool = {
          prompt = false;
          keepBackup = false;
          diffview = { cmd = "nvim -n -c DiffviewOpen"; };
        };
        push.default = "tracking";
        hub.host = cfg.hubHost;
        lfs.lockverify = false;
      };

      ignores = [
        ".java_version"
        ".metals"
        "metals.sbt"
        ".bloop"
        ".idea"
        ".DS_Store"
        ".envrc"
        "shell.nix"
      ];

      delta.enable = true;
      delta.options = {
        kanagawa = {
          file-style = "cyan ul";
          file-decoration-style = "blue ul";
          minus-style = "black red";
          minus-emph-style = "ul black brightred";
          minus-empty-line-marker-style = "black red";
          line-numbers-minus-style = "brightred black";
          zero-style = "blue";
          plus-style = "black green";
          plus-emph-style = "ul black brightgreen";
          line-numbers-plus-style = "brightgreen black";
          whitespace-error-style = "auto auto";
          blame-code-style = "auto auto";
          true-color = "auto";
          file-modified-label = "changed";
          hyperlinks = "true";
          keep-plus-minus-markers = "true";
          diff-stat-align-width = "10";
          syntax-theme = "Nord";
        };
        features = "kanagawa";
        side-by-side = true;
      };
    };

    programs.broot.enable = true;

    programs.bat = {
      enable = true;
      config.theme = "Nord";
    };

    programs.fzf = {
      enable = true;
      historyWidgetOptions = [ "--reverse" ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.eza = {
      enable = true;
      icons = "auto";
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    home.packages = with pkgs; [
      act
      avro-tools
      bazelisk
      cmake
      colima
      coreutils
      curl
      d2
      delta
      duf
      fd
      fx
      gettext
      gh
      gitAndTools.hub
      gnupg
      gnused
      graphviz-nox
      grpcurl
      html-tidy
      httpie
      hugo
      imagemagick
      jless
      jq
      k9s
      kind
      krew
      kubebuilder
      kubectx
      kubernetes
      kubernetes-helm
      kustomize
      languagetool
      ltex-ls
      lua
      marksman
      minikube
      moreutils
      nixfmt-classic
      nixpkgs-fmt
      nodejs_20
      nurl
      operator-sdk
      pandoc
      pluto
      postgresql_16
      pqrs
      protobuf
      ripgrep
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
    ];
  };
}
