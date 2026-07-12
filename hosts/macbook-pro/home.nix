{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/common/claude
    ../../modules/home-manager/common/codex
    ../../modules/home-manager/darwin/karabiner
    ./modules/claude.nix
  ];

  home.username = "thomashexton";
  home.homeDirectory = "/Users/thomashexton";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    unstable.codex
    mcp-nixos
  ];
}
