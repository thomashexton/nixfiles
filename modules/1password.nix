{
  darwin.personal =
    { pkgs, ... }:
    {
      programs._1password-gui = {
        enable = true;
        package = pkgs.unstable._1password-gui;
      };
    };

  nixos.personal =
    { pkgs, ... }:
    {
      programs._1password-gui = {
        enable = true;
        package = pkgs.unstable._1password-gui;
      };
    };
}
