{
  darwin.base.homebrew = {
    taps = [ "deskflow/tap" ];
    casks = [ "deskflow" ];
  };

  # Deskflow otherwise uses different state directories depending on whether
  # Finder or a shell with XDG_CONFIG_HOME launches it. Keep one mutable set of
  # settings, TLS certificates, and trusted fingerprints for both launch paths.
  home.darwin =
    { config, ... }:
    {
      home.file."Library/Deskflow" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/Deskflow";
      };
    };

  nixos.deskflowServer =
    { pkgs, ... }:
    {
      home-manager.users.thomashexton =
        { config, ... }:
        {
          xdg.configFile."Deskflow/Deskflow.conf" = {
            force = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/deskflow/Deskflow.conf";
          };

          xdg.configFile."Deskflow/deskflow-server.conf" = {
            force = true;
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/deskflow/deskflow-server.conf";
          };
        };

      environment.systemPackages = [
        pkgs.unstable.deskflow
        pkgs.wl-clipboard # Remove once Deskflow uses portal clipboard support.
        pkgs.qt6.qtsvg # Deskflow's tray icon otherwise fails to render.
      ];

      networking.firewall.allowedTCPPorts = [ 24800 ];
      networking.interfaces.enp14s0.wakeOnLan.enable = true;

      # Keep the Deskflow server reachable when unattended.
      systemd.targets.sleep.enable = false;
      systemd.targets.suspend.enable = false;
      systemd.targets.hibernate.enable = false;
      systemd.targets.hybrid-sleep.enable = false;
    };
}
