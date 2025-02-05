{ inputs, config, pkgs, lib, outputs, ... }:

{

  imports = [ ./development ];

  home.stateVersion = "24.05";

  home.sessionPath = [ "$HOME/scripts" "$HOME/bin" "$HOME/.cargo/bin" ];

  programs = {
    home-manager = { enable = true; };

    vscode = { enable = true; };
  };

  development = {
    enable = true;
    userName = "mgthesecond";
    userEmail = "mgthesecond@spotify.com";
    hubHost = "ghe.spotify.net";

    rust.enable = true;
    gcloud.enable = true;
    qmk.enable = true;
    python.enable = true;
    graphql.enable = true;
    copilot.enable = true;
    roc.enable = true;

    jvm = {
      enable = true;
      mavenRepositories = [
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
      # Blocked on: 
      # https://github.com/NixOS/nixpkgs/pull/368726
      # https://github.com/ghostty-org/ghostty/discussions/2824
      #inputs.ghostty.packages.aarch64-darwin.default
      dbt
      viu
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ];

  home.file = {
    "ghostty" = {
      source = lib.cleanSource ./development/config/ghostty/config;
      target = ".config/ghostty/config";
    };
  };

}
