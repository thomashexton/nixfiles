{ ... }:

{
  programs.alacritty = {
    enable = true;
    package = null;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 15.0;
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular Italic";
        };
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };
      window = {
        decorations = "buttonless";
        opacity = 1;
        padding.x = 20;
      };
      general.live_config_reload = true;
      keyboard.bindings = [
        {
          key = "Return";
          mods = "Shift";
          chars = "\\u001b\\r";
        }
        {
          key = "T";
          mods = "Control";
          chars = "\\u0002c";
        }
        {
          key = "W";
          mods = "Control";
          chars = "\\u0002x";
        }
        {
          key = "K";
          mods = "Control";
          chars = "\\u0002s";
        }
        {
          key = "Key1";
          mods = "Control";
          chars = "\\u00021";
        }
        {
          key = "Key2";
          mods = "Control";
          chars = "\\u00022";
        }
        {
          key = "Key3";
          mods = "Control";
          chars = "\\u00023";
        }
        {
          key = "Key4";
          mods = "Control";
          chars = "\\u00024";
        }
        {
          key = "Key5";
          mods = "Control";
          chars = "\\u00025";
        }
        {
          key = "Key6";
          mods = "Control";
          chars = "\\u00026";
        }
        {
          key = "Key7";
          mods = "Control";
          chars = "\\u00027";
        }
        {
          key = "Key8";
          mods = "Control";
          chars = "\\u00028";
        }
        {
          key = "Key9";
          mods = "Control";
          chars = "\\u00029";
        }
      ];
    };
  };
}
