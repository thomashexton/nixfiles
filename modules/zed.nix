{
  home.workstation =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        nixfmt
        nodejs_22
        zed-editor
      ];

      xdg.configFile."zed/settings.json" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/modules/zed/settings.json";
      };
    };
}
