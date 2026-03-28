{ config, ... }:

let
  repoRoot = "${config.home.homeDirectory}/nixfiles";
in
{
  home.file.".codex/config.toml" = {
    force = true;
    source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/modules/home-manager/common/codex/config.toml";
  };
}
