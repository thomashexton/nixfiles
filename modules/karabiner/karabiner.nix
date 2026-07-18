{
  darwin.base.services.karabiner-elements.enable = true;

  home.darwin =
    { config, ... }:
    {
      home.file.".config/karabiner/karabiner.json" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/karabiner/karabiner.json";
      };
    };
}
