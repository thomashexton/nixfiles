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

  nixos.workstation =
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

  home.personal =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.just ];
    };
}
