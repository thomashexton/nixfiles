{ config, pkgs, zen-browser, ... }:

{
  imports = [
    ../../modules/home-manager/common/zed.nix
    ../../modules/home-manager/linux/hyprland.nix
    ../../modules/home-manager/linux/waybar.nix
  ];

  home.username = "thomashexton";
  home.homeDirectory = "/home/thomashexton";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = [
    zen-browser.packages."${pkgs.system}".twilight
  ];

  # Host-specific overrides can go here
  # For example:
  # wayland.windowManager.hyprland.settings.monitor = [
  #   "HDMI-A-1,2560x1440@144,0x0,1"  # Override for specific monitor setup
  # ];
}
