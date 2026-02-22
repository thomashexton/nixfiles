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
        work-laptop:
    end

    section: links
        hxtn:
            up = work-laptop
        work-laptop:
            down = hxtn
    end

    section: options
        keystroke(super+1) = switchToScreen(hxtn)
        keystroke(super+2) = switchToScreen(work-laptop)
        keystroke(super+shift+l) = lockCursorToScreen(toggle)
    end
  '';
}
