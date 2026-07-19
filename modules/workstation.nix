{ inputs, ... }:

{
  nixos.workstation =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;

      programs.firefox.enable = true;
      environment.systemPackages = [ pkgs.ghostty ];
    };

  home.workstation =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
      ];
    };
}
