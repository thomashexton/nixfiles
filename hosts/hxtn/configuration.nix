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
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
   };
    # amdgpu.amdvlk = {
    #     enable = true;
    #     support32Bit.enable = true;
    # };
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
    protonup-qt
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
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    fish = {
      enable = true;
      shellAliases = {
        rb = "sudo nixos-rebuild build --flake ~/nixfiles#hxtn";
        rb-test = "sudo nixos-rebuild test --flake ~/nixfiles#hxtn";
        rb-switch = "sudo nixos-rebuild switch --flake ~/nixfiles#hxtn";
        update = "nix flake update --flake ~/nixfiles";
        ll = "ls -la";
      };
    };
  };

  system.stateVersion = "25.05";
}
