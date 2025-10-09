{ config, pkgs, ... }:

{
  # AeroSpace window manager - macOS only
  # This would never work on Linux, so it belongs in darwin/
  
  home.packages = with pkgs; [
    # aerospace  # Hypothetical package
  ];

  # AeroSpace configuration would go here
  # xdg.configFile."aerospace/aerospace.toml".text = ''
  #   # AeroSpace config
  # '';
}
