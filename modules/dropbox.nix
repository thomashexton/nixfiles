{
  # nixpkgs currently packages Dropbox only for Linux.
  darwin.personal.homebrew.casks = [ "dropbox" ];

  nixos.personal =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.dropbox ];
    };
}
