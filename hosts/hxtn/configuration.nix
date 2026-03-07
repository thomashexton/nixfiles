{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/deskflow.nix
  ];

  # ===========================================================================
  # Boot & Hardware Config
  # ===========================================================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "ntsync" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernel.sysctl."vm.swappiness" = 10;
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      # Use unstable mesa for GPU drivers only (DRI/Vulkan) — keeps stable
      # mesa for system services like SDDM to avoid OpenGL init breakage
      package = pkgs.unstable.mesa;
      package32 = pkgs.unstable.mesa;
   };
  };

  # ===========================================================================
  # Core System Config
  # ===========================================================================

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "hxtn";

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_AU.UTF-8";

  # ===========================================================================
  # System Services Config
  # ===========================================================================

  networking.networkmanager.enable = true;

  # Prevent sleep/suspend — hxtn is always-on as a Deskflow KVM server
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
          };
        };
      };
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse = {
      enable = true;
    };
    jack.enable = true;
    extraConfig.pipewire."92-low-latency" =
      let quantum = 512; # tune between 512-1024; lower = less latency, higher = less crackling
      in {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = quantum;
          "default.clock.min-quantum" = quantum;
          "default.clock.max-quantum" = quantum;
        };
      };
  };

  # ===========================================================================
  # Desktop Environment Config
  # ===========================================================================

  # Plasma 6 + SDDM
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  # ===========================================================================
  # Users & Packages Config
  # ===========================================================================

  users.users.thomashexton = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBw2OMn/ZEtk9CRa9vrKLSRAscXoF7TGxwKdDSo1obnO"
    ];
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alacritty
    alejandra
    fish
    fishPlugins.autopair
    fishPlugins.done
    fishPlugins.z
    git
    ghostty
    mangohud
    nil
    nixfmt-rfc-style
    nodejs_20
    pavucontrol
    tree
    vim
    wget
    zed-editor
  ];

  programs = {
    firefox = {
      enable = true;
      # package = pkgs.firefox-wayland;
    };
    steam = {
      enable = true;
      extest.enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = "1";
          MANGOHUD_CONFIG = "read_cfg,no_display";
        };
      };
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    gamemode.enable = true;
    gamescope.enable = true; # makes binary available system-wide; use via Steam launch options per-game

    fish.enable = true;
  };

  system.stateVersion = "25.05";
}
