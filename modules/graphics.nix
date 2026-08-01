{
  nixos.workstation =
    { pkgs, ... }:
    {
      services.lact.enable = true;

      environment.systemPackages = with pkgs; [
        mesa-demos
        vulkan-tools
      ];
    };
}
