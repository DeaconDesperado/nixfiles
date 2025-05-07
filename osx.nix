{ pkgs, lib, ... }:

let
  configFile =
    builtins.readFile (./development/config/aerospace/aerospace.toml);

in {

  environment.systemPackages = [ pkgs.aerospace ];

  launchd.user.agents.aerospace = {
    command =
      "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
      + " --config-path ${configFile}";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };

  };

  services = {
    sketchybar = {
      enable = true;
      extraPackages = [ pkgs.jq ];
    };
  };

  system.defaults = {
    # Hide the menu bar to instead use sketchybar
    NSGlobalDomain._HIHideMenuBar = true;
  };

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
