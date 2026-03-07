{ config, pkgs, ... }:

{
  home.username = "thomashexton";
  home.homeDirectory = "/Users/thomashexton";
  home.stateVersion = "24.11";

  imports = [
    ../../modules/home-manager/common/fish.nix
    ../../modules/home-manager/common/git.nix
    ../../modules/home-manager/common/zed.nix
  ];

  programs.home-manager.enable = true;
}
