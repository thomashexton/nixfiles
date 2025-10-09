{ config, pkgs, ... }:

{
  # Note: Package is installed at system level
  
  # Zed configuration managed declaratively
  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    ui_font_size = 13;
    buffer_font_size = 13;
    theme = {
      mode = "system";
      light = "One Dark";
      dark = "One Dark";
    };
    languages = {
      Nix = {
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
