# Shared nix-darwin baseline for both Macs, including home-manager wiring.
{ inputs, config, ... }:

{
  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      imports = [
        inputs.determinate.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
      ];

      determinateNix.enable = true;

      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "aarch64-darwin";
      system.primaryUser = "thomashexton";

      users.users.thomashexton.home = "/Users/thomashexton";

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "pre-nix";
      home-manager.users.thomashexton.imports = [ config.flake.modules.homeManager.base ];

      environment.systemPackages = with pkgs; [
        fish
        fishPlugins.autopair
        fishPlugins.done
        fishPlugins.z
        tree
      ];
    };
}
