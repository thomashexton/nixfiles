{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.unstable.deskflow ];

  # Open the Deskflow port (24800) for incoming client connections
  networking.firewall.allowedTCPPorts = [ 24800 ];

  # Autostart deskflow server under Plasma Wayland session
  systemd.user.services.deskflow-server = {
    description = "Deskflow KVM server";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.unstable.deskflow}/bin/deskflow-core server";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

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
