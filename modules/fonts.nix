let
  nerdFonts = pkgs: [
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.jetbrains-mono
  ];
in
{
  darwin.workstation =
    { pkgs, ... }:
    {
      fonts.packages = nerdFonts pkgs;
    };

  nixos.workstation =
    { pkgs, ... }:
    {
      fonts.packages = nerdFonts pkgs;
    };
}
