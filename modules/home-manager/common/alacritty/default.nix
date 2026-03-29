{ config, ... }:

let
  repoRoot = "${config.home.homeDirectory}/nixfiles";
in
{
  xdg.configFile."alacritty/alacritty.toml" = {
    force = true;
    source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/modules/home-manager/common/alacritty/alacritty.toml";
  };
}
