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

  # Deskflow autostart (KDE system tray)
  xdg.configFile."autostart/org.deskflow.deskflow.desktop".text = ''
    [Desktop Entry]
    Categories=Utility;
    Comment=Mouse and keyboard sharing utility
    Exec=deskflow
    Icon=org.deskflow.deskflow
    Keywords=keyboard;mouse;sharing;network;share;
    Name=Deskflow
    Terminal=false
    Type=Application
  '';
}
