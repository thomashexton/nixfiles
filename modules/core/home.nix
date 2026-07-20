{
  home.base =
    { pkgs, ... }:
    {
      home.username = "thomashexton";
      home.homeDirectory =
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users/thomashexton" else "/home/thomashexton";
      home.stateVersion = "24.11";

      manual.manpages.enable = false;
      programs.home-manager.enable = true;
    };
}
