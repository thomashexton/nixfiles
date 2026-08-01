{
  darwin.personal.home-manager.users.thomashexton =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.unstable.streamrip ];
    };
}
