{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/common/tmux.nix
  ];

  home.username = "thomashexton";
  home.homeDirectory = "/Users/thomashexton";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    just
    mcp-nixos
  ];
}
