{
  darwin.workstation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.obsidian ];
    };

  nixos.workstation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.obsidian ];
    };
}
