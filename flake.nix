{
  description = "NixOS and nix-darwin host configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    determinate.url = "github:DeterminateSystems/determinate";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, determinate, nix-darwin, home-manager, zen-browser, ... }:
    let
      unstable-overlay = _final: prev:
        let
          unstablePkgs = import nixpkgs-unstable {
            system = prev.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        in {
          unstable = unstablePkgs;
        };
    in {
    # NixOS configuration for desktop
    nixosConfigurations = {
      hxtn = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs.overlays = [ unstable-overlay ]; }
          ./hosts/hxtn/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.thomashexton = import ./hosts/hxtn/home.nix;
            home-manager.extraSpecialArgs = { inherit zen-browser; };
          }
        ];
      };
    };

    # Darwin configurations for macOS
    darwinConfigurations = {
      macbook-pro = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          { nixpkgs.overlays = [ unstable-overlay ]; }
          determinate.darwinModules.default
          ./hosts/macbook-pro/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "pre-nix";
            home-manager.users.thomashexton = import ./hosts/macbook-pro/home.nix;
            home-manager.extraSpecialArgs = { inherit zen-browser; };
          }
        ];
      };

      mac-mini = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          { nixpkgs.overlays = [ unstable-overlay ]; }
          determinate.darwinModules.default
          ./hosts/mac-mini/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "pre-nix";
            home-manager.users.thomashexton = import ./hosts/mac-mini/home.nix;
            home-manager.extraSpecialArgs = { inherit zen-browser; };
          }
        ];
      };
    };
  };
}
