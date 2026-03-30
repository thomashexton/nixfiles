{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/common/claude
    ./modules/claude.nix
  ];

  home.username = "thomashexton";
  home.homeDirectory = "/Users/thomashexton";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
