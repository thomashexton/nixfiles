{
  darwin.base.homebrew = {
    taps = [ "deskflow/tap" ];
    casks = [ "deskflow" ];
  };

  nixos.deskflowServer =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.unstable.deskflow
        pkgs.qt6.qtsvg # Required for Deskflow system tray icon rendering
      ];

      networking.firewall.allowedTCPPorts = [ 24800 ];
      networking.interfaces.enp14s0.wakeOnLan.enable = true;

      # Keep the Deskflow server reachable when unattended.
      systemd.targets.sleep.enable = false;
      systemd.targets.suspend.enable = false;
      systemd.targets.hibernate.enable = false;
      systemd.targets.hybrid-sleep.enable = false;

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
      '';
    };
}
