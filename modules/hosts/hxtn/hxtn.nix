{ config, inputs, ... }:

{
  flake.nixosConfigurations.hxtn = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.nixos.base
      config.nixos.workstation
      config.nixos.personal
      config.nixos.gaming
      config.nixos.deskflowServer
      config.nixos.remoteAccess
      ./_hardware-configuration.nix
      (
        { pkgs, ... }:
        {
          networking.hostName = "hxtn";
          time.timeZone = "Australia/Sydney";
          i18n.defaultLocale = "en_AU.UTF-8";

          boot.loader.systemd-boot.enable = true;
          boot.loader.timeout = 10;
          boot.loader.efi.canTouchEfiVariables = true;

          boot.kernelPackages = pkgs.linuxPackages_latest;
          boot.kernelModules = [ "ntsync" ];
          boot.initrd.kernelModules = [ "amdgpu" ];
          boot.kernel.sysctl = {
            "vm.swappiness" = 10;
            "vm.max_map_count" = 2147483642;
          };

          zramSwap = {
            enable = true;
            algorithm = "zstd";
            memoryPercent = 25;
          };

          hardware = {
            amdgpu.overdrive.enable = true;
            graphics = {
              enable = true;
              enable32Bit = true;
            };
          };

          users.users.thomashexton = {
            isNormalUser = true;
            extraGroups = [
              "wheel"
              "networkmanager"
            ];
            shell = pkgs.fish;
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAWmZ5MK+XXYlgK7u7RrRxZAThUFN6DUjbcWBBTZ5Pxr hxtn"
            ];
          };

          system.stateVersion = "25.05";
        }
      )
    ];
  };
}
