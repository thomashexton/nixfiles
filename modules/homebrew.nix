# Shared Homebrew baseline; hosts add their own brews/casks on top.
{
  flake.modules.darwin.homebrew = {
    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = false;
        upgrade = false;
        cleanup = "none";
      };

      taps = [
        "deskflow/tap"
        "nikitabobko/tap"
      ];

      casks = [
        "aerospace"
        "appcleaner"
        "deskflow"
        "karabiner-elements"
      ];
    };
  };
}
