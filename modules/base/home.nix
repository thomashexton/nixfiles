# Shared home-manager baseline for thomashexton on every host.
{
  home.base =
    { pkgs, ... }:
    {
      home.username = "thomashexton";
      home.homeDirectory =
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users/thomashexton" else "/home/thomashexton";
      home.stateVersion = "24.11";

      programs.home-manager.enable = true;
    };
}
