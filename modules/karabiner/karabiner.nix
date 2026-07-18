{
  # Karabiner-Elements owns all keyboard remapping on macOS:
  #   - Caps Lock -> Left Control (all keyboards)
  #   - Right Option <-> Right Command, MX Keys Mini only (Logi Bolt receiver,
  #     vendor 1133 / product 50504)
  # Out-of-store symlink so the committed config is the source of truth. Note:
  # editing keyboard remaps via Karabiner's UI will overwrite this file.
  home.darwin =
    { config, ... }:
    {
      home.file.".config/karabiner/karabiner.json" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/karabiner/karabiner.json";
      };
    };

  darwin.base.homebrew.casks = [ "karabiner-elements" ];
}
