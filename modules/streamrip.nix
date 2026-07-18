# Personal music tooling used on the Mac desktop.
{
  home.darwinPersonal =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.unstable.streamrip ];
    };
}
