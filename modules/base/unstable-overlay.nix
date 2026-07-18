# Exposes nixpkgs-unstable as pkgs.unstable on every host.
{ inputs, ... }:

let
  unstable-overlay = _final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
in
{
  flake.modules.darwin.base.nixpkgs.overlays = [ unstable-overlay ];
  flake.modules.nixos.base.nixpkgs.overlays = [ unstable-overlay ];
}
