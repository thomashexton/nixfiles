{ config, ... }:

let
  repoRoot = "${config.home.homeDirectory}/nixfiles";
in
{
  # Karabiner-Elements owns all keyboard remapping on macOS:
  #   - Caps Lock -> Left Control (all keyboards)
  #   - Right Option <-> Right Command, MX Keys Mini only (Logi Bolt receiver,
  #     vendor 1133 / product 50504)
  # Out-of-store symlink so the committed config is the source of truth. Note:
  # editing keyboard remaps via Karabiner's UI will overwrite this file.
  home.file.".config/karabiner/karabiner.json" = {
    force = true;
    source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/modules/home-manager/darwin/karabiner/karabiner.json";
  };
}
