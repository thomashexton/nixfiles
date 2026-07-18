{
  darwin.workstation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.alacritty ];
    };

  nixos.workstation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.alacritty ];
    };

  home.personal =
    { config, pkgs, ... }:
    {
      xdg.configFile."alacritty/alacritty.toml" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/alacritty/alacritty.toml";
      };

      # "buttonless" is macOS-only; isolate it so the shared live config stays portable.
      xdg.configFile."alacritty/decorations.toml".text = ''
        [window]
        decorations = "${if pkgs.stdenv.hostPlatform.isDarwin then "buttonless" else "full"}"
      '';
    };
}
