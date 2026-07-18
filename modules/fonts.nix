# Fonts used by terminals and editors on configured desktops.
let
  nerdFonts = pkgs: [
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.jetbrains-mono
  ];
in
{
  darwin.base =
    { pkgs, ... }:
    {
      fonts.packages = nerdFonts pkgs;
    };

  nixos.desktop =
    { pkgs, ... }:
    {
      fonts.packages = nerdFonts pkgs;
    };
}
