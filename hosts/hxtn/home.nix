{ lib, pkgs, zen-browser, ... }:

{
  imports = [
    ../../modules/home-manager/common/codex.nix
    ../../modules/home-manager/common/git.nix
    ../../modules/home-manager/common/tmux.nix
    ../../modules/home-manager/common/zed.nix
  ];

  home.username = "thomashexton";
  home.homeDirectory = "/home/thomashexton";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    unstable.codex
    just
    mcp-nixos
    tmux
    zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
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

  home.activation.plasmaKeyboardRepeat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Keyboard --key RepeatDelay 200
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Keyboard --key RepeatRate 40
  '';
}
