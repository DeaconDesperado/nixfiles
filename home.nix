{ inputs, config, pkgs, lib, outputs, ... }:

{

  imports = [ ./development ];

  home.stateVersion = "24.05";

  home.sessionPath = [ "$HOME/scripts" "$HOME/bin" "$HOME/.cargo/bin" ];

  programs = {
    home-manager = { enable = true; };

    vscode = { enable = true; };

    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };
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
      inputs.ghostty.packages.aarch64-darwin.default
      dbt
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ];

}
