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
  darwin.base.nixpkgs.overlays = [ unstable-overlay ];
  nixos.base.nixpkgs.overlays = [ unstable-overlay ];
}
