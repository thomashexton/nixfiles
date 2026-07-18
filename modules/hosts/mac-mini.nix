{ config, inputs, ... }:

{
  flake.darwinConfigurations.mac-mini = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      config.darwin.base
      config.darwin.workstation
      config.darwin.personal
      (
        { ... }:
        {
          networking.hostName = "mac-mini";
          networking.localHostName = "mac-mini";
          networking.computerName = "Thomas's Mac Mini";

          system.stateVersion = 5;
        }
      )
    ];
  };
}
