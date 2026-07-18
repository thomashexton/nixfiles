# Keyboard remapping and configuration tools for the NixOS desktop.
{
  nixos.desktop =
    { pkgs, ... }:
    {
      services.keyd = {
        enable = true;
        keyboards.default = {
          ids = [ "*" ];
          settings.main.capslock = "overload(control, esc)";
        };
      };

      services.udev.packages = [ pkgs.vial ];
      environment.systemPackages = [ pkgs.vial ];
    };
}
