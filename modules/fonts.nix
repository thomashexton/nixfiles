# Fonts used by terminals and editors on the Macs.
{
  darwin.base =
    { pkgs, ... }:
    {
      fonts.packages = [
        pkgs.nerd-fonts.hack
        pkgs.nerd-fonts.iosevka
        pkgs.nerd-fonts.jetbrains-mono
      ];
    };
}
