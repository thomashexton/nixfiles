{ config, pkgs, ... }:

{
  imports = [
    ../../modules/darwin/packages.nix
    ../../modules/darwin/kanata.nix
    ../../modules/darwin/homebrew.nix
  ];

  determinateNix.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "thomashexton";

  users.users.thomashexton.home = "/Users/thomashexton";

  homebrew = {
    brews = [ "mas" ];
    casks = [ "1password" "cursor" "dropbox" ];
    masApps = { Metadatics = 554883654; };
  };

  # System packages for macOS
  environment.systemPackages = with pkgs; [
    fish
    fishPlugins.autopair
    fishPlugins.done
    fishPlugins.z
    tree
  ];

  networking.hostName = "mac-mini";
  networking.localHostName = "mac-mini";
  networking.computerName = "Thomas's Mac Mini";

  system.stateVersion = 5;
}
