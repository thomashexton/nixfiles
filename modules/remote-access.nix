{
  nixos.remoteAccess = {
    services.avahi = {
      enable = true;
      allowInterfaces = [ "enp14s0" ];
      # IPv6 address changes caused mDNS hostname conflicts during boot.
      ipv6 = false;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
      extraServiceFiles.smb = ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    services.samba = {
      enable = true;
      nmbd.enable = false;
      winbindd.enable = false;
      settings = {
        global = {
          security = "user";
          "map to guest" = "Never";
          "server min protocol" = "SMB3_00";
          "smb encrypt" = "required";
          "vfs objects" = "fruit streams_xattr";
          "fruit:metadata" = "stream";
          "fruit:model" = "MacSamba";
        };

        thomashexton = {
          path = "/home/thomashexton";
          comment = "Thomas Hexton's home directory";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "valid users" = [ "thomashexton" ];
          "create mask" = "0600";
          "directory mask" = "0700";
        };
      };
    };

    # SMB over TCP; Avahi opens UDP 5353 for local discovery itself.
    networking.firewall.allowedTCPPorts = [ 445 ];
  };
}
