{
  darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.appcleaner ];
    };
}
