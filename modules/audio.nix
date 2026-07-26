{
  nixos.workstation =
    { pkgs, ... }:
    let
      # The RØDECaster Duo exposes three logical stereo devices across its two
      # physical USB connections. ALSA/WirePlumber's profile-index names are
      # opaque, so give each Pro Audio node the name used by RØDE:
      #   USB1 pro-{output,input}-1 = Main
      #   USB1 pro-{output,input}-0 = Chat
      #   USB2 pro-{output,input}-0 = Secondary
      #
      # These identifiers come from the unit's USB descriptors and remain stable
      # across reboots and probe order.
      rodeUsb1 = "usb-R__DE_RODECaster_Duo_IT0003959-00";
      rodeUsb2 = "usb-R__DE_R__DECaster_Duo-00";
      renameRode = device: stream: profile: displayName: {
        matches = [ { "node.name" = "alsa_${stream}.${device}.${profile}"; } ];
        actions.update-props = {
          "node.description" = displayName;
          "node.nick" = displayName;
        };
      };
    in
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
        extraConfig.pipewire."low-latency" =
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

        # Rename the RØDECaster's stereo pairs to the friendly names.
        # Only the display name changes — node.name is untouched, so KDE's saved
        # per-device volumes and default-device choice carry over unchanged.
        wireplumber.extraConfig."rodecaster-names" = {
          "monitor.alsa.rules" = [
            (renameRode rodeUsb1 "output" "pro-output-1" "RØDE Main")
            (renameRode rodeUsb1 "output" "pro-output-0" "RØDE Chat")
            (renameRode rodeUsb1 "input" "pro-input-1" "RØDE Main")
            (renameRode rodeUsb1 "input" "pro-input-0" "RØDE Chat")
            (renameRode rodeUsb2 "output" "pro-output-0" "RØDE Secondary")
            (renameRode rodeUsb2 "input" "pro-input-0" "RØDE Secondary")
          ];
        };
      };

      environment.systemPackages = [ pkgs.pavucontrol ];
    };
}
