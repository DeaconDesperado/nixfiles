{ inputs, lib, config, pkgs, outputs, ... }:

{

  home.file = {
    "config.kdl" = {
      source = lib.cleanSource ./config/zellij/config.kdl;
      target = ".config/zellij/config.kdl";
    };

    "layouts" = {
      source = lib.cleanSource ./config/zellij/layouts;
      target = ".config/zellij/layouts";
    };
    "alacritty.toml" = {
      source = lib.cleanSource ./config/alacritty/alacritty.toml;
      target = ".config/alacritty/alacritty.toml";
    };
  };

  programs.alacritty = { enable = true; };

  programs.htop.enable = true;

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

  programs.git = {
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
    icons = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [ zsh-completions zellij ];
}
