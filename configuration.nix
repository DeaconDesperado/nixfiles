{ pkgs, lib, ... }:

{
  # Nix configuration ------------------------------------------------------------------------------

  nix.settings = {
    trusted-users = [ "@admin" ];
    substituters = [ "https://cache.nixos.org/" ];
    auto-optimise-store = false;
    trusted-public-keys =
      [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  };

  ids.gids.nixbld = 30000;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Let Home Manager initialize completion. Enabling it here as well makes
  # nix-darwin run an uncached compinit before the cached user configuration.
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    enableBashCompletion = false;
  };

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [ terminal-notifier ];

  programs.nix-index.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    recursive
    nerd-fonts.mononoki
    iosevka-bin
    (iosevka-bin.override { variant = "SS09"; })
    font-awesome
    cascadia-code
    fira-code
    jetbrains-mono
    intel-one-mono
    nanum-gothic-coding
  ];

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 5;
}
