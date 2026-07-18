# KDE Plasma desktop and its Home Manager user experience.
{ config, inputs, ... }:

{
  nixos.plasma =
    { pkgs, ... }:
    {
      home-manager.users.thomashexton.imports = [ config.home.plasma ];

      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      networking.networkmanager.enable = true;
      programs.firefox.enable = true;
      environment.systemPackages = [ pkgs.ghostty ];
    };

  home.plasma =
    { lib, pkgs, ... }:
    {
      home.packages = [
        inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
      ];

      home.activation.plasmaKeyboardRepeat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Keyboard --key RepeatDelay 200
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Keyboard --key RepeatRate 40
      '';
    };
}
