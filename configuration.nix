{ pkgs, lib, ... }:

{
  # Nix configuration ------------------------------------------------------------------------------

  nix.settings = {
    trusted-users = [ "@admin" ];
    substituters = [ "https://cache.nixos.org/" ];
    trusted-public-keys =
      [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  };

  ids.gids.nixbld = 30000; 
  nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

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
  security.pam.enableSudoTouchIdAuth = true;

  system.stateVersion = 5;
}
