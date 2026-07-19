{ lib, flake-parts-lib, ... }:

let
  deferredProfile =
    description:
    lib.mkOption {
      inherit description;
      type = lib.types.deferredModule;
      default = { };
    };
in
{
  options = {
    darwin = {
      base = deferredProfile "Foundation shared by every nix-darwin host.";
      workstation = deferredProfile "Interactive nix-darwin workstation applications and tooling.";
      personal = deferredProfile "Personal nix-darwin applications and policy.";
      professional = deferredProfile "Professional nix-darwin applications and policy.";
    };

    nixos = {
      base = deferredProfile "Foundation shared by every NixOS host.";
      workstation = deferredProfile "Interactive NixOS workstation hardware, applications, and tooling.";
      personal = deferredProfile "Personal NixOS applications and policy.";
      gaming = deferredProfile "NixOS gaming applications and system support.";
      plasma = deferredProfile "KDE Plasma NixOS desktop environment.";
      hyprland = deferredProfile "Hyprland NixOS desktop environment.";
      deskflowServer = deferredProfile "Deskflow server role for NixOS.";
      remoteAccess = deferredProfile "Remote access services for NixOS.";
    };

    home = {
      base = deferredProfile "Home Manager configuration shared by every user environment.";
      workstation = deferredProfile "Home Manager applications and configuration shared by workstations.";
      darwin = deferredProfile "Home Manager configuration shared by nix-darwin hosts.";
      personal = deferredProfile "Personal Home Manager configuration.";
      professional = deferredProfile "Professional Home Manager configuration.";
      gaming = deferredProfile "Gaming-related Home Manager configuration.";
      plasma = deferredProfile "KDE Plasma Home Manager configuration.";
      hyprland = deferredProfile "Hyprland Home Manager configuration.";
    };

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
