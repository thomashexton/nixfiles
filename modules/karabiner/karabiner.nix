{
  # Karabiner 15.7 replaced its legacy launchd services with v2 app bundles.
  # nix-darwin's service module still references the removed legacy plists, so
  # let the upstream cask install and manage Karabiner's privileged services.
  darwin.base.homebrew.casks = [ "karabiner-elements" ];

  home.darwin =
    { config, ... }:
    {
      home.file.".config/karabiner/karabiner.json" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/karabiner/karabiner.json";
      };
    };
}
