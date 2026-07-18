{ config, inputs, ... }:

{
  flake.darwinConfigurations.macbook-pro = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      config.darwin.base
      config.darwin.canva
      (
        { ... }:
        {
          networking.hostName = "macbook-pro";
          networking.localHostName = "macbook-pro";
          networking.computerName = "Thomas's MacBook Pro";

          system.stateVersion = 5;
        }
      )
    ];
  };
}
