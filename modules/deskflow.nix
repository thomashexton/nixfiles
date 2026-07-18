{
  nixos.deskflowServer =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.unstable.deskflow
        pkgs.qt6.qtsvg # Required for Deskflow system tray icon rendering
      ];

      # Open the Deskflow port (24800) for incoming client connections
      networking.firewall.allowedTCPPorts = [ 24800 ];
      networking.interfaces.enp14s0.wakeOnLan.enable = true;

      # This machine is the always-on Deskflow server.
      systemd.targets.sleep.enable = false;
      systemd.targets.suspend.enable = false;
      systemd.targets.hibernate.enable = false;
      systemd.targets.hybrid-sleep.enable = false;

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
    };

  darwin.base.homebrew = {
    taps = [ "deskflow/tap" ];
    casks = [ "deskflow" ];
  };
}
