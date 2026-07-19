{ config, ... }:

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

    };

  home.plasma =
    { lib, pkgs, ... }:
    {
      home.activation.plasmaKeyboardRepeat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Keyboard --key RepeatDelay 200
        ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Keyboard --key RepeatRate 40
      '';
    };
}
