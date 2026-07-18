# Graphics tooling for the AMD NixOS workstation.
{
  nixos.desktop =
    { pkgs, ... }:
    {
      services.lact.enable = true;

      environment.systemPackages = with pkgs; [
        mesa-demos
        vulkan-tools
      ];
    };
}
