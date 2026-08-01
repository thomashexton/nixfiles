{
  # nixpkgs builds ghostty on Linux only; darwin needs the prebuilt attribute.
  darwin.workstation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ghostty-bin ];
    };

  nixos.workstation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ghostty ];
    };
}
