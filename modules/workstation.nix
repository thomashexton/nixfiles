{ inputs, ... }:

{
  nixos.workstation =
    { ... }:
    {
      networking.networkmanager.enable = true;

      programs.firefox.enable = true;
      # Let tools such as Zed run generic Linux binaries downloaded by extensions.
      programs.nix-ld.enable = true;
    };

  home.workstation =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
      ];
    };
}
