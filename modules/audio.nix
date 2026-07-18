# Low-latency desktop audio for NixOS workstations.
{
  nixos.workstation =
    { pkgs, ... }:
    {
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        extraConfig.pipewire."92-low-latency" =
          let
            quantum = 512;
          in
          {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.quantum" = quantum;
              "default.clock.min-quantum" = quantum;
              "default.clock.max-quantum" = quantum;
            };
          };
      };

      environment.systemPackages = [ pkgs.pavucontrol ];
    };
}
