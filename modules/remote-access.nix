# Hardened SSH access for remotely managed NixOS machines.
{
  nixos.remoteAccess = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
