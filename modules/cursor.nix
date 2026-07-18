{
  darwin.personal =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.code-cursor ];
    };

  nixos.personal =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.code-cursor ];
    };
}
