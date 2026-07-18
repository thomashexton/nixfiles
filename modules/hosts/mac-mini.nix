{ config, inputs, ... }:

{
  flake.darwinConfigurations.mac-mini = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      config.flake.modules.darwin.base
      config.flake.modules.darwin.packages
      config.flake.modules.darwin.homebrew
      (
        { pkgs, ... }:
        {
          networking.hostName = "mac-mini";
          networking.localHostName = "mac-mini";
          networking.computerName = "Thomas's Mac Mini";

          homebrew = {
            brews = [ "mas" ];
            casks = [ "1password" "cursor" "dropbox" ];
            masApps = { Metadatics = 554883654; };
          };

          home-manager.users.thomashexton = {
            imports = with config.flake.modules.homeManager; [
              aerospace
              alacritty
              claude
              codex
              git
              karabiner
              tmux
              zsh
            ];

            home.packages = with pkgs; [
              just
              mcp-nixos
              unstable.streamrip
            ];
          };

          system.stateVersion = 5;
        }
      )
    ];
  };
}
