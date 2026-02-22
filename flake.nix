{
  description = "Minimal NixOS/Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, zen-browser, ... }:
    let
      unstable-overlay = final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
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
      work-laptop = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          { nixpkgs.overlays = [ unstable-overlay ]; }
          ./hosts/work-laptop/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.thomashexton = import ./hosts/work-laptop/home.nix;
            home-manager.extraSpecialArgs = { inherit zen-browser; };
          }
        ];
      };

      mac-mini = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          { nixpkgs.overlays = [ unstable-overlay ]; }
          ./hosts/mac-mini/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.thomashexton = import ./hosts/mac-mini/home.nix;
            home-manager.extraSpecialArgs = { inherit zen-browser; };
          }
        ];
      };
    };
  };
}
