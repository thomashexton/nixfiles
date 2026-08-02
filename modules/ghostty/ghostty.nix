{
  home.base =
    { config, ... }:
    {
      xdg.configFile."ghostty/config" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/ghostty/config";
      };
    };

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
