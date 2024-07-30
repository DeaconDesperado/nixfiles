{ config, pkgs, lib, outputs, ... }:

{

  imports = [ ./development ];

  development = {
    enable = true;
    userName = "mgthesecond";
    userEmail = "mgthesecond@spotify.com";
    hubHost = "ghe.spotify.net";

    gcloud.enable = true;
    qmk.enable = true;
    python.enable = true;

    jvm = {
      enable = true;
      mavenRepositories = [
        { artifactory = "https://artifactory.spotify.net/artifactory/repo"; }
        "local"
        "maven-central"
      ];
    };
  };

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

  home.packages = with pkgs;
    [
      # AWS
      unstable.awscli2
      dbt
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ];

}
