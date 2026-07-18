# Shared NixOS baseline, including home-manager wiring.
{ inputs, config, ... }:

{
  flake.modules.nixos.base = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    nixpkgs.config.allowUnfree = true;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.thomashexton.imports = [ config.flake.modules.homeManager.base ];
  };
}
