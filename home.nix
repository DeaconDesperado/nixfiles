{ inputs, config, pkgs, lib, outputs, ... }:

{

  imports = [ ./development ];

  home.stateVersion = "24.05";

  home.sessionPath = [
    "$HOME/scripts"
    "$HOME/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/projects/foss/rdf2dot/packages/rdf2dot/bin"
  ];

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
    ai.enable = true;
    ontology = {
      enable = true;
      atlasNotesDir = "~/Desktop/mgii-work";
    };

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
      viu
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
      aerospace
      sketchybar
    ];
}
