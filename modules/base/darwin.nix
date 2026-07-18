{ inputs, config, ... }:

{
  darwin.base =
    { ... }:
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
      home-manager.users.thomashexton.imports = [
        config.home.base
        config.home.darwin
      ];
    };

  darwin.personal.home-manager.users.thomashexton.imports = [ config.home.personal ];

  darwin.professional.home-manager.users.thomashexton.imports = [ config.home.professional ];
}
