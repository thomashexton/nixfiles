{ inputs, ... }:

{
  nixos.workstation =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;

      programs.firefox.enable = true;
      # Let tools such as Zed run generic Linux binaries downloaded by extensions.
      programs.nix-ld.enable = true;
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
