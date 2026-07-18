# Shared home-manager baseline for thomashexton on every host.
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.username = "thomashexton";
      home.homeDirectory =
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users/thomashexton" else "/home/thomashexton";
      home.stateVersion = "24.11";

      programs.home-manager.enable = true;
    };
}
