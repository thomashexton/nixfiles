{ config, pkgs, ... }:

{
  imports = [
    ../../modules/darwin/common/homebrew.nix
  ];

  determinateNix.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "thomashexton";

  users.users.thomashexton.home = "/Users/thomashexton";

  # System packages for macOS
  environment.systemPackages = with pkgs; [
    fish
    fishPlugins.autopair
    fishPlugins.done
    fishPlugins.z
    git
    tree
  ];

  networking.hostName = "macbook-pro";
  networking.localHostName = "macbook-pro";
  networking.computerName = "Thomas's MacBook Pro";

  system.stateVersion = 5;
}
