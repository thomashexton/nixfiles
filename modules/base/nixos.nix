# Shared NixOS baseline, including home-manager wiring.
{ inputs, config, ... }:

{
  nixos.base = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.thomashexton.imports = [ config.home.base ];
  };

  nixos.desktop.home-manager.users.thomashexton.imports = [
    config.home.desktop
    config.home.nixosDesktop
  ];

  nixos.gaming.home-manager.users.thomashexton.imports = [ config.home.gaming ];
}
