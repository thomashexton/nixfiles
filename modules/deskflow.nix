{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.unstable.deskflow ];

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
        # TODO: consider adding a keystroke to lock cursor to screen
        # if it becomes annoying losing the mouse to hxtn when not in use
        # keystroke(super+shift+l) = lockCursorToScreen(toggle)
    end
  '';

  # Generate a self-signed TLS cert for Deskflow on activation
  system.activationScripts.deskflowTls = ''
    mkdir -p /etc/Deskflow/tls
    if [ ! -f /etc/Deskflow/tls/deskflow.pem ]; then
      ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 3650 \
        -newkey rsa:2048 \
        -keyout /etc/Deskflow/tls/deskflow.pem \
        -out /etc/Deskflow/tls/deskflow.pem \
        -subj '/CN=hxtn' 2>/dev/null
    fi
  '';
}
