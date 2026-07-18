# Declares the dendritic "catalog": flake.modules.<class>.<name> holds named
# deferred modules (nixos / darwin / homeManager fragments) that feature files
# publish and host files consume.
{ lib, flake-parts-lib, ... }:

{
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    modules = lib.mkOption {
      description = "Deferred modules, grouped by class (nixos, darwin, homeManager).";
      type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
      default = { };
    };

    # flake-parts core declares nixosConfigurations but not darwinConfigurations;
    # without this, host files defining one entry each would conflict.
    darwinConfigurations = lib.mkOption {
      description = "nix-darwin system configurations.";
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = { };
    };
  };

  config.systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];
}
