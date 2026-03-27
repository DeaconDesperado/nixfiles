{
  description = "MGII system";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    ghostty.url = "github:ghostty-org/ghostty";
    roc.url = "github:roc-lang/roc";
    # Always latest
    claude-code.url = "github:sadjow/claude-code-nix";
    qlue_ls = {
      url = "github:DeaconDesperado/Qlue-ls/dev";
      flake = false;
    };
    qlue_ls_nvim = {
      url = "github:DeaconDesperado/qluels-nvim/dev";
      flake = false;
    };
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
        XW6K07YF0K = let userName = "mgthesecond"; in darwinSystem {
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
              home-manager.users.${userName} = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
              users.users.${userName}.home = "/Users/${userName}";
            }
          ];
          specialArgs = { inherit inputs userName; };
        };
      };

      # Overlays --------------------------------------------------------------- {{{

      overlays = {

        neovim-nightly = inputs.neovim-nightly-overlay.overlays.default;

        claude-code = inputs.claude-code.overlays.default;

        # Overlays to add various packages into package set
        pkgs-unstable = final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv.hostPlatform) system;
            inherit (nixpkgsConfig) config;
          };
        };
      };
    };
}
