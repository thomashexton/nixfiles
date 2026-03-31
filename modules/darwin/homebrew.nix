{ ... }:

{
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
}
