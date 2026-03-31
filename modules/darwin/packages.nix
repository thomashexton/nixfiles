{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    difftastic
    fd
    fzf
    gh
    git
    kanata
    lazygit
    neovim
    stow
    tmux
    tree-sitter
    alacritty
    zed-editor
  ];

  fonts.packages = [
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
