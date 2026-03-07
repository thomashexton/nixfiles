{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # Makes fish a valid login shell — registers it in /etc/shells
  # User-level fish config is managed by home-manager (modules/home-manager/common/fish.nix)
  programs.fish.enable = true;

  # System packages for macOS
  environment.systemPackages = with pkgs; [
    alacritty
    git
    ghostty
    tree
    zed-editor
  ];

  system.stateVersion = 5;
}