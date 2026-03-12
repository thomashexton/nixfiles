{ ... }:

{
  # Keep Homebrew in place during the migration and only let nix-darwin
  # declare the inventory. Unmanaged packages stay installed until cleanup
  # is intentionally tightened later.
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

    brews = [
      "difftastic"
      "fd"
      "fzf"
      "gh"
      "git"
      "kanata"
      "lazygit"
      "neovim"
      "stow"
      "tmux"
      "tree-sitter-cli"
    ];

    casks = [
      "aerospace"
      "alacritty"
      "appcleaner"
      "deskflow"
      "font-hack-nerd-font"
      "font-iosevka-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "karabiner-elements"
      "zed"
    ];
  };
}
