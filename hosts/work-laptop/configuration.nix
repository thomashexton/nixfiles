{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # System packages for macOS
  environment.systemPackages = with pkgs; [
    alacritty
    fish
    fishPlugins.autopair
    fishPlugins.done
    fishPlugins.z
    git
    ghostty
    tree
    zed-editor
  ];

  system.stateVersion = 5;
}