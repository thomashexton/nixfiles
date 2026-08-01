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

      home.activation.plasmaVirtualDesktopShortcuts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        kwrite=${pkgs.kdePackages.kconfig}/bin/kwriteconfig6

        "$kwrite" --file "$HOME/.config/kwinrc" --group Desktops --key Number 10
        "$kwrite" --file "$HOME/.config/kwinrc" --group Desktops --key Rows 1

        for desktop in 1 2 3 4 5 6 7 8 9 10; do
          shortcut_number="$desktop"
          if [ "$desktop" -eq 10 ]; then
            shortcut_number=0
          fi

          switch_shortcut="Alt+$shortcut_number"
          window_shortcut="Ctrl+Alt+$shortcut_number"

          "$kwrite" --file "$HOME/.config/kglobalshortcutsrc" --group kwin \
            --key "Switch to Desktop $desktop" \
            "$switch_shortcut,$switch_shortcut,Switch to Desktop $desktop"

          "$kwrite" --file "$HOME/.config/kglobalshortcutsrc" --group kwin \
            --key "Window to Desktop $desktop" \
            "$window_shortcut,$window_shortcut,Window to Desktop $desktop"
        done
      '';
    };
}
