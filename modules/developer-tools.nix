# Interactive development tools shared by the configured desktops.
{
  darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        difftastic
        fd
        fzf
        gh
        lazygit
        neovim
        stow
        tree-sitter
      ];
    };

  nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nixd
        nixfmt-rfc-style
        nodejs_20
        vim
        wget
      ];
    };

  home.desktop =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.just ];
    };
}
