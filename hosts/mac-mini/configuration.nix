{ config, pkgs, ... }:

{
  imports = [
    ../../modules/darwin/common/homebrew.nix
    ../../modules/darwin/roles/personal-homebrew.nix
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

  system.stateVersion = 5;
}
