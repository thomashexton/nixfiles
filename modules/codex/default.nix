{
  flake.modules.homeManager.codex =
    { config, ... }:
    {
      home.file.".codex/config.toml" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/codex/config.toml";
      };
    };
}
