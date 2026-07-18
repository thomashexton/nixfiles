# Shared CLI tools and fonts for the Macs.
{
  flake.modules.darwin.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        difftastic
        fd
        fzf
        gh
        git
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
    };
}
