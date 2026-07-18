# Personal music tooling used on the Mac desktop.
{
  home.darwinDesktop =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.unstable.streamrip ];
    };
}
