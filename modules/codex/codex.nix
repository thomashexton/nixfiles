{
  home.base =
    { config, pkgs, ... }:
    {
      home.packages = [
        pkgs.unstable.codex
        pkgs.mcp-nixos
      ];

      home.file.".codex/config.toml" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/codex/config.toml";
      };
    };
}
