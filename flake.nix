{
  description = "Minimal NixOS/Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, zen-browser, ... }: {
    # NixOS configuration for desktop
    nixosConfigurations = {
      hxtn = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
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

    # Darwin configuration for macOS
    darwinConfigurations = {
      canva-laptop = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/canva-laptop/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.thomashexton = import ./hosts/canva-laptop/home.nix;
            home-manager.extraSpecialArgs = { inherit zen-browser; };
          }
        ];
      };
    };
  };
}