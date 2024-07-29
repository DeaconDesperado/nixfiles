{ config, pkgs, lib, outputs, ... }: {
  
  imports = [
    ./vim
    ./shell
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
    "googlestyle.xml" = {
      source = lib.cleanSource ./config/codestyle/googlestyle.xml; 
      target = ".config/codestyle/googlestyle.xml";
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

    vscode = {
      enable = true;
    };

    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

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
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ];

}
