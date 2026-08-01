{
  description = "NixOS and nix-darwin host configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    import-tree.url = "github:vic/import-tree";
    determinate.url = "github:DeterminateSystems/determinate";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Deskflow InputCapture needs a matching Hyprland/XDPH pair. Remove these
    # pins when the selected nixpkgs release provides one.
    hyprland = {
      url = "github:hyprwm/Hyprland/466f6bc53f44c42fd7d8f8c01eeaec112112aefd";
      inputs.xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland/0e832b50ecc49d4bae01a29845c1b3fafc5c5c99";
    };
    nix-citizen.url = "github:LovingMelody/nix-citizen";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
