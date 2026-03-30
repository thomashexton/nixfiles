{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [
    pkgs.unstable.deskflow
    pkgs.qt6.qtsvg # Required for Deskflow system tray icon rendering
  ];

  # Open the Deskflow port (24800) for incoming client connections
  networking.firewall.allowedTCPPorts = [ 24800 ];

  # Deskflow server config (screen layout)
  environment.etc."Deskflow/deskflow-server.conf".text = ''
    section: screens
        hxtn:
        macbook-pro:
    end

    section: links
        hxtn:
            up = macbook-pro
        macbook-pro:
            down = hxtn
    end

    section: options
        # keystroke(F4) = switchToScreen(hxtn)
        # keystroke(F5) = switchToScreen(macbook-pro)
        # keystroke(super+shift+l) = lockCursorToScreen(toggle)
    end
  '';
}
