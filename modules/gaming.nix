{ inputs, ... }:

{
  nixos.gaming =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-citizen.nixosModules.default ];

      nix.settings.extra-substituters = [ "https://nix-citizen.cachix.org" ];
      nix.settings.extra-trusted-public-keys = [
        "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
      ];

      environment.sessionVariables.MANGOHUD_CONFIGFILE = "/home/thomashexton/.config/MangoHud/hxtn-mangohud.conf";

      environment.systemPackages = with pkgs; [
        bottles
        unstable.faugus-launcher
        unstable.goverlay
        lutris
        unstable.mangohud
        protontricks
      ];

      programs = {
        steam = {
          enable = true;
          package = pkgs.steam.override {
            extraEnv = {
              MANGOHUD = "1";
              MANGOHUD_CONFIG = "read_cfg,no_display";
            };
          };
          extraCompatPackages = [ pkgs.proton-ge-bin ];
        };

        gamemode.enable = true;
        gamescope.enable = true;

        rsi-launcher = {
          enable = true;
          umu.enable = true;
          preCommands = ''
            export MANGOHUD=1
            export MANGOHUD_CONFIG=read_cfg
          '';
        };
      };
    };

  home.gaming =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        discord
        wowup-cf
      ];

      xdg.configFile."MangoHud/hxtn-mangohud.conf" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/mangohud.conf";
      };
    };
}
