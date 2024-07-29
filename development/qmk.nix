{ lib, config, ... }:
let cfg = config.development.qmk;
in {
  options = {
    development.qmk.enable = lib.mkEnableOption "Enable QMK Module";
  };

  config = lib.mkIf cfg.enable {
    #config contents
    home.packages = with pkgs; [ keymapviz ];
  };
}
