{
  nixos.workstation =
    { pkgs, ... }:
    {
      services.keyd = {
        enable = true;
        # Other keyboards are programmed in QMK, so don't intercept them.
        # keyboards.default = {
        #   ids = [ "*" ];
        #   settings.main.capslock = "overload(control, esc)";
        # };

        # Logitech's USB vendor ID is k:046d:c548.  Keep this macOS-style modifier
        # placement local to Logitech keyboards instead of changing the
        # laptop's built-in keyboard or any other external keyboard.
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
