{
  darwin.workstation =
    { pkgs, ... }:
    {
      # Keep the GUI application system-wide on both Macs. The user
      # configuration is enabled by the desktop home profile.
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

      # Window decorations differ by platform: "buttonless" is macOS-only and
      # Linux Alacritty warns on it. Kept in a tiny generated file imported by
      # alacritty.toml, so the main config stays one shared, live-editable file.
      xdg.configFile."alacritty/decorations.toml".text = ''
        [window]
        decorations = "${if pkgs.stdenv.hostPlatform.isDarwin then "buttonless" else "full"}"
      '';
    };
}
