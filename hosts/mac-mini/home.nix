{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/common/alacritty.nix
    ../../modules/home-manager/common/claude.nix
    ../../modules/home-manager/common/codex.nix
    ../../modules/home-manager/common/git.nix
    ../../modules/home-manager/common/tmux.nix
    ../../modules/home-manager/common/zsh.nix
    ../../modules/home-manager/darwin/aerospace.nix
    ../../modules/home-manager/darwin/kanata.nix
    ./modules/migration-cleanup.nix
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
