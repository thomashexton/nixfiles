{ inputs, config, ... }:

let
  baseHome = config.home.base;
in
{
  nixos.base =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.gc = {
        automatic = true;
        dates = "weekly";
      };
      systemd.services.nix-gc.preStart = ''
        ${config.nix.package.out}/bin/nix-env \
          --profile /nix/var/nix/profiles/system \
          --delete-generations +10
      '';

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.thomashexton.imports = [ baseHome ];
    };

  nixos.workstation.home-manager.users.thomashexton.imports = [ config.home.workstation ];

  nixos.personal.home-manager.users.thomashexton.imports = [ config.home.personal ];

  nixos.gaming.home-manager.users.thomashexton.imports = [ config.home.gaming ];
}
