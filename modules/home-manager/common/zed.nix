{ pkgs, ... }:

{
  # Note: Package is installed at system level
  
  # Zed configuration managed declaratively
  xdg.configFile."zed/settings.json".source =
    (pkgs.formats.json { }).generate "zed-settings.json" {
      ui_font_size = 13;
      buffer_font_size = 13;
      theme = {
        mode = "system";
        light = "One Dark";
        dark = "One Dark";
      };
      node = {
        path = "${pkgs.nodejs_22}/bin/node";
        npm_path = "${pkgs.nodejs_22}/bin/npm";
        ignore_system_version = false;
      };
      languages = {
        Nix = {
          language_servers = [
            "nixd"
          ];
          formatter = {
            external = {
              command = "nixfmt";
              arguments = [];
            };
          };
        };
      };
    };
}
