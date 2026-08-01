{
  nixos.workstation =
    { pkgs, ... }:
    {
      services.keyd = {
        enable = true;
        # Other keyboards are programmed in QMK, so keep this modifier layout
        # local to Logitech devices.
        keyboards.logitech = {
          ids = [ "k:046d:c548" ];
          settings.main = {
            capslock = "overload(control, esc)";
            rightmeta = "rightalt";
            rightalt = "rightmeta";
          };
        };
      };

      services.udev.packages = [ pkgs.vial ];
      environment.systemPackages = [ pkgs.vial ];
    };
}
