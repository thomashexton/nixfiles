{ lib, flake-parts-lib, ... }:

let
  deferredProfiles =
    description:
    lib.mkOption {
      inherit description;
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
    };
in
{
  options = {
    darwin = deferredProfiles "nix-darwin capability profiles.";
    nixos = deferredProfiles "NixOS capability profiles.";
    home = deferredProfiles "Home Manager capability profiles.";

    flake = flake-parts-lib.mkSubmoduleOptions {
      # flake-parts core declares nixosConfigurations but not
      # darwinConfigurations; this makes separately declared hosts merge.
      darwinConfigurations = lib.mkOption {
        description = "nix-darwin system configurations.";
        type = lib.types.lazyAttrsOf lib.types.raw;
        default = { };
      };
    };
  };

  config.systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];
}
