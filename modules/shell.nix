{
  darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        fish
        fishPlugins.autopair
        fishPlugins.done
        fishPlugins.z
        tree
      ];
    };

  nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        fish
        fishPlugins.autopair
        fishPlugins.done
        fishPlugins.z
        tree
      ];

      programs.fish.enable = true;
    };
}
