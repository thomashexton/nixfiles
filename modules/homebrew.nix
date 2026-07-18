# Shared Homebrew behavior. Feature modules own their taps, brews, and casks.
{
  darwin.base = {
    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = false;
        upgrade = false;
        cleanup = "none";
      };

      casks = [ "appcleaner" ];
    };
  };
}
