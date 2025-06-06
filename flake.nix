{
  description = "MGII system";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    ghostty.url = "github:ghostty-org/ghostty";
    roc.url = "github:roc-lang/roc";
  };

  outputs = { self, darwin, nixpkgs, home-manager, roc, ... }@inputs:

    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib)
        attrValues makeOverridable optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {

        config = {
          allowBroken = true;
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };

        overlays = attrValues self.overlays;
      };
    in {
      darwinConfigurations = rec {
        XW6K07YF0K = darwinSystem {
          system = "aarch64-darwin";
          modules = [
            # Main `nix-darwin` config
            ./configuration.nix
            # `home-manager` module
            home-manager.darwinModules.home-manager
            ./osx.nix
            {
              nixpkgs = nixpkgsConfig;
              # `home-manager` config
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mgthesecond = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
              users.users.mgthesecond.home = "/Users/mgthesecond";
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };

      # Overlays --------------------------------------------------------------- {{{

      overlays = {

        neovim-nightly = inputs.neovim-nightly-overlay.overlays.default;

        # Overlays to add various packages into package set
        pkgs-unstable = final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
      };
    };
}
