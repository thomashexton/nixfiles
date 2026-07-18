{ config, inputs, ... }:

{
  flake.darwinConfigurations.macbook-pro = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      config.flake.modules.darwin.base
      config.flake.modules.darwin.packages
      config.flake.modules.darwin.homebrew
      (
        { pkgs, ... }:
        {
          networking.hostName = "macbook-pro";
          networking.localHostName = "macbook-pro";
          networking.computerName = "Thomas's MacBook Pro";

          home-manager.users.thomashexton = {
            imports = with config.flake.modules.homeManager; [
              claude
              claude-work
              codex
              karabiner
            ];

            home.packages = with pkgs; [
              unstable.codex
              mcp-nixos
            ];
          };

          system.stateVersion = 5;
        }
      )
    ];
  };
}
