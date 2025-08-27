{ lib, config, pkgs, ... }:
let cfg = config.development.gcloud;
in {
  options = { development.gcloud.enable = lib.mkEnableOption "Enable Module"; };

  config = lib.mkIf cfg.enable {
    #config contents
    home.packages = with pkgs; [
      google-cloud-sql-proxy
      google-cloud-bigtable-tool
      (google-cloud-sdk.withExtraComponents ([
        google-cloud-sdk.components.gke-gcloud-auth-plugin
        google-cloud-sdk.components.pubsub-emulator
      ]))
    ];
  };
}
