{ config, pkgs, zen-browser, ... }:

{
  imports = [
    ../../modules/home-manager/common/zed.nix
  ];

  home.username = "thomashexton";
  home.homeDirectory = "/home/thomashexton";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = [
    zen-browser.packages."${pkgs.system}".twilight
  ];

  # Host-specific overrides can go here
}
