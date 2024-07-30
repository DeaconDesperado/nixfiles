{ inputs, lib, config, pkgs, ... }:
with lib;
let cfg = config.development.jvm;
in {

  options.development.jvm = {
    enable = mkEnableOption "Enable JVM development";
    mavenRepositories = mkOption {
      type = types.listOf
        (types.either (types.enum [ "local" "maven-central" "maven-local" ])
          (types.attrsOf types.str));
      default = [ "local" "maven-central" ];
    };
  };

  config = mkIf cfg.enable {
    programs.sbt = {
      enable = true;
      repositories = cfg.mavenRepositories;
    };

    home.packages = with pkgs; [
      coursier
      gradle
      jdt-language-server
      leiningen
      maven
      metals
      scala
      scala-cli
      scalafmt
    ];
  };

}
