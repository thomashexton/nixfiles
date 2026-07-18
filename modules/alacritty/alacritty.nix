{
  flake.modules.homeManager.alacritty =
    { config, ... }:
    {
      xdg.configFile."alacritty/alacritty.toml" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/alacritty/alacritty.toml";
      };
    };
}
