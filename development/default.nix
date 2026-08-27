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
    ./cpp.nix
    ./jvm.nix
    ./gcloud.nix
    ./qmk.nix
    ./python.nix
    ./roc.nix
    ./ontology.nix
    ./graphql.nix
    ./ai.nix
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
    shellFunctions = mkOption { type = types.lines; };
  };

  config = mkIf cfg.enable {

    home.file = {
      eldritch_theme_btop = {
        source = "${eldritch_repo}/eldritch.theme";
        target = "./.config/btop/themes/eldritch.theme";
      };

      "ghostty" = {
        source = lib.cleanSource ./config/ghostty/config;
        target = ".config/ghostty/config";
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

      bglass = {
        executable = true;
        source = lib.cleanSource ./scripts/bglass;
        target = "./scripts/bglass";
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
      completionInit = ''
        autoload -Uz compinit

        _zcompdump="''${ZDOTDIR:-$HOME}/.zcompdump"
        _stale_compdumps=("''${_zcompdump}"(N.mh+24))

        if [[ ! -s "$_zcompdump" ]] || (( $#_stale_compdumps )); then
          compinit -d "$_zcompdump"
        else
          compinit -C -d "$_zcompdump"
        fi

        if [[ -s "$_zcompdump" &&
              ( ! -s "$_zcompdump.zwc" || "$_zcompdump" -nt "$_zcompdump.zwc" ) ]]; then
          zcompile "$_zcompdump"
        fi

        unset _zcompdump _stale_compdumps
      '';
      syntaxHighlighting = { enable = true; };
      autosuggestion = { enable = false; };
      history.extended = true;
      profileExtra = ''
        export PATH="$PATH:/Users/mgthesecond/Library/Application Support/JetBrains/Toolbox/scripts"

        eval "$(/opt/homebrew/bin/brew shellenv)"

        source ~/.orbstack/shell/init.zsh 2>/dev/null || :

        export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
      '';
      shellAliases = {
        cat = "bat";
        #git = "hub";
        k = "kubectl";
        bazel = "bazelisk";
        top = "btop";
        jless = "jless --mode line";
        yesterday = "date -d 'yesterday' +%Y%m%d";
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
      initContent =
        let
          rg_fzf = builtins.readFile (./config/zsh/rg_fzf.sh);
          zellij_aliases = builtins.readFile (./config/zellij/aliases.sh);
          zellij_tab_name_update = builtins.readFile (./config/zsh/zellij_tab_name_update.zsh);
          instantPrompt = lib.mkOrder 500 ''
            if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
              source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
            fi
          '';
          generalConfig = lib.mkOrder 1000 ''
            export WORDCHARS='*?[]~=&;!#$%^(){}<>'
            export USE_GKE_GCLOUD_AUTH_PLUGIN=True
            export LSP_USE_PLISTS=true
            export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,bg=bold,underline"
            export PATH=$PATH:/opt/homebrew/bin:$HOME/go/bin:/opt/spotify-cli/bin:$HOME/.npm-global:$HOME/.npm-global/bin

            # Alacritty encodes Shift+Arrow as CSI 1;2D/C. Bind these explicitly so
            # they remain word-navigation keys when passed through Zellij.
            bindkey $'\e[1;2D' backward-word
            bindkey $'\e[1;2C' forward-word

            export FZF_DEFAULT_OPTS=" \
            --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
            --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
            --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

            git_ri() {
              git ri "$@"
            }

            ${rg_fzf}

            ${zellij_aliases}

            ${cfg.shellFunctions}

            ${zellij_tab_name_update}
          '';
        in
        lib.mkMerge [
          instantPrompt
          generalConfig
        ];
    };

    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = cfg.userName;
        user.email = cfg.userEmail;

        alias = {
          s = "status";
          l =
            "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          changes = ''
            !f() {
              color=0
              test -t 1 && color=1

              branch=$(git symbolic-ref --quiet --short HEAD || :)
              remote=$(git config --get "branch.$branch.remote" || :)
              base=""

              if test -n "$remote" && test "$remote" != "."; then
                base=$(git symbolic-ref --quiet --short "refs/remotes/$remote/HEAD" || :)
              fi
              if test -z "$base"; then
                base=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD || :)
              fi
              if test -z "$base"; then
                base=$(git for-each-ref --format='%(symref:short)' 'refs/remotes/*/HEAD' |
                  awk 'NF { print; exit }')
              fi
              if test -z "$base"; then
                echo "Unable to determine the default branch from a remote HEAD." >&2
                echo "Run 'git remote set-head <remote> --auto' to record it." >&2
                return 1
              fi

              git log --reverse --format='COMMIT%x09%h%x09%ad%x09%s' --date=short --numstat "$base"..HEAD |
                awk -F '\t' -v color="$color" '
                  BEGIN {
                    if (color) {
                      reset = "\033[0m"
                      hash_color = "\033[1;38;2;126;156;216m"
                      date_color = "\033[38;2;220;165;97m"
                      add_color = "\033[38;2;118;148;106m"
                      del_color = "\033[38;2;195;64;67m"
                      files_color = "\033[38;2;106;149;137m"
                      subject_color = "\033[38;2;200;192;147m"
                    }
                  }
                  /^COMMIT/ {
                    if (seen) print_commit()
                    hash=$2; date=$3; subject=$4; adds=dels=files=0; seen=1; next
                  }
                  NF >= 3 {
                    files++
                    if ($1 ~ /^[0-9]+$/) {
                      adds += $1
                      total_adds += $1
                    }
                    if ($2 ~ /^[0-9]+$/) {
                      dels += $2
                      total_dels += $2
                    }
                    if (!($3 in changed_files)) {
                      changed_files[$3] = 1
                      total_files++
                    }
                  }
                  END {
                    if (seen) {
                      print_commit()
                      print_summary()
                    }
                  }
                  function print_commit() {
                    printf "%s%-9s%s  %s%s%s  %s+%-6d%s %s-%-6d%s %s%3d files%s  %s%s%s\n", \
                      hash_color, hash, reset, date_color, date, reset, \
                      add_color, adds, reset, del_color, dels, reset, \
                      files_color, files, reset, subject_color, subject, reset
                  }
                  function print_summary() {
                    net = total_adds - total_dels
                    net_color = net >= 0 ? add_color : del_color
                    printf "%s%-21s%s  %s+%-6d%s %s-%-6d%s %snet %+-6d%s %s%3d files%s\n", \
                      hash_color, "TOTAL", reset, add_color, total_adds, reset, \
                      del_color, total_dels, reset, net_color, net, reset, \
                      files_color, total_files, reset
                  }
                '
            }; f
          '';
          ri = ''
            !f() {
              branch=$(git symbolic-ref --quiet --short HEAD || :)
              remote=$(git config --get "branch.$branch.remote" || :)
              base=""

              if test -n "$remote" && test "$remote" != "."; then
                base=$(git symbolic-ref --quiet --short "refs/remotes/$remote/HEAD" || :)
              fi
              if test -z "$base"; then
                base=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD || :)
              fi
              if test -z "$base"; then
                base=$(git for-each-ref --format='%(symref:short)' 'refs/remotes/*/HEAD' |
                  awk 'NF { print; exit }')
              fi
              if test -z "$base"; then
                echo "Unable to determine the default branch from a remote HEAD." >&2
                echo "Run 'git remote set-head <remote> --auto' to record it." >&2
                return 1
              fi

              merge_base=$(git merge-base HEAD "$base") || return
              git rebase -i "$merge_base"
            }; f
          '';
          revise = "commit -a --amend --no-edit";
        };

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
        ".local-dev"
      ];

    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        kanagawa = {
          # File headers — crystalBlue with sumiInk6 decoration
          file-style = "#7E9CD8 bold ul";
          file-decoration-style = "#54546D ul";
          file-added-label = "[+]";
          file-modified-label = "[~]";
          file-removed-label = "[-]";
          file-renamed-label = "[>]";

          # Hunk headers — oniViolet file, autumnYellow line numbers
          hunk-header-style = "file line-number syntax";
          hunk-header-decoration-style = "#54546D box";
          hunk-header-file-style = "#957FB8";
          hunk-header-line-number-style = "#DCA561";

          # Removed lines — winterRed backgrounds
          minus-style = "syntax \"#43242B\"";
          minus-emph-style = "syntax \"#5D2D3A\"";
          minus-empty-line-marker-style = "syntax \"#43242B\"";
          minus-non-emph-style = "syntax \"#43242B\"";

          # Added lines — winterGreen backgrounds
          plus-style = "syntax \"#2B3328\"";
          plus-emph-style = "syntax \"#365040\"";
          plus-empty-line-marker-style = "syntax \"#2B3328\"";
          plus-non-emph-style = "syntax \"#2B3328\"";

          # Context lines
          zero-style = "syntax";

          # Line numbers — autumnRed / autumnGreen / sumiInk6
          line-numbers = true;
          line-numbers-minus-style = "#C34043";
          line-numbers-plus-style = "#76946A";
          line-numbers-zero-style = "#54546D";

          # Blame — alternating sumiInk backgrounds
          blame-code-style = "syntax";
          blame-palette = "#1F1F28 #2A2A37 #363646";

          # General
          true-color = "always";
          syntax-theme = "Nord";
          navigate = true;
          hyperlinks = true;
          whitespace-error-style = "#C34043 reverse";
          keep-plus-minus-markers = true;
          diff-stat-align-width = 10;

          # Merge conflicts
          merge-conflict-begin-symbol = "▼";
          merge-conflict-end-symbol = "▲";
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
      historyWidget.options = [ "--reverse" ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = { warn_timeout = "120s"; };
      package = pkgs.direnv.overrideAttrs { doCheck = false; };
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
      bazel-buildtools
      bazelisk
      cmake
      chafa
      colima
      coreutils
      curl
      delta
      duf
      fd
      fx
      gettext
      gh
      #ghostty
      gnupg
      gnused
      graphviz-nox
      grpcurl
      html-tidy
      httpie
      hub
      hugo
      hydra-check
      imagemagick
      jless
      jq
      kubectl
      kubectx
      languagetool
      ltex-ls
      lua
      marksman
      moreutils
      nixfmt
      nixpkgs-fmt
      nodejs_22
      nurl
      operator-sdk
      pandoc
      pluto
      pnpm
      postgresql_16
      pqrs
      protobuf
      ripgrep
      semver-tool
      shellcheck
      texlab
      tldr
      trino-cli
      watch
      watchexec
      wget
      yarn
      yq-go
      zellij
      zsh-completions
    ];
  };
}
