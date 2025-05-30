{ inputs, config, pkgs, lib, outputs, ... }:

{

  imports = [ ./development ];

  home.stateVersion = "24.05";

  home.sessionPath =
    [ "$HOME/scripts" "$HOME/bin" "$HOME/.cargo/bin" "$HOME/.local/bin" ];

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
    cpp.enable = true;
    gcloud.enable = true;
    qmk.enable = true;
    python.enable = true;
    graphql.enable = true;
    copilot.enable = true;
    roc.enable = true;
    ontology.enable = true;

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
      viu
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
      aerospace
      sketchybar
    ];

  home.file = {
    "ghostty" = {
      source = lib.cleanSource ./development/config/ghostty/config;
      target = ".config/ghostty/config";
    };
  } // lib.optionals pkgs.stdenv.isDarwin {
    #"aerospace.toml" = {
    #  source = lib.cleanSource ./development/config/aerospace/aerospace.toml;
    #  target = ".aerospace.toml";
    #};
    #"sketchybar" = {
    #  source = lib.cleanSource ./development/config/sketchybar;
    #  target = ".config/sketchybar";
    #  recursive = true;
    #};
  };
}
