{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.unstable.deskflow ];

  # Open the Deskflow port (24800) for incoming client connections
  networking.firewall.allowedTCPPorts = [ 24800 ];

  # Autostart Deskflow GUI under Plasma Wayland session (KDE autostart)
  environment.etc."xdg/autostart/deskflow.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Deskflow
    Exec=${pkgs.unstable.deskflow}/bin/deskflow
    X-KDE-autostart-phase=2
  '';

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
        # TODO: consider adding a keystroke to lock cursor to screen
        # if it becomes annoying losing the mouse to hxtn when not in use
        # keystroke(super+shift+l) = lockCursorToScreen(toggle)
    end
  '';
}
