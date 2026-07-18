{ config, inputs, ... }:

{
  flake.nixosConfigurations.hxtn = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.nixos.base
      config.flake.modules.nixos.deskflow
      inputs.nix-citizen.nixosModules.default
      ./_hardware-configuration.nix
      (
        { lib, pkgs, ... }:
        {
          nixpkgs.overlays = [ (_final: prev: { unixodbc = prev.unixODBC; }) ];

          # =====================================================================
          # Boot & Hardware Config
          # =====================================================================

          boot.loader.systemd-boot.enable = true;
          boot.loader.timeout = 10;
          boot.loader.efi.canTouchEfiVariables = true;

          boot.kernelPackages = pkgs.linuxPackages_latest;
          boot.kernelModules = [ "ntsync" ];
          boot.initrd.kernelModules = [ "amdgpu" ];
          boot.kernel.sysctl."vm.swappiness" = 10;
          boot.kernel.sysctl."vm.max_map_count" = 2147483642;

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

          # =====================================================================
          # Core System Config
          # =====================================================================

          nix.settings.experimental-features = [ "nix-command" "flakes" ];
          nix.settings.extra-substituters = [ "https://nix-citizen.cachix.org" ];
          nix.settings.extra-trusted-public-keys = [
            "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
          ];
          # Allow Zed's bundled Node-based language servers to run on NixOS.
          # programs.nix-ld.enable = true;

          networking.hostName = "hxtn";

          time.timeZone = "Australia/Sydney";
          i18n.defaultLocale = "en_AU.UTF-8";

          # =====================================================================
          # System Services Config
          # =====================================================================

          networking.networkmanager.enable = true;
          networking.interfaces.enp14s0.wakeOnLan.enable = true;

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

          # =====================================================================
          # Desktop Environment Config
          # =====================================================================

          # Plasma 6 + SDDM
          services = {
            desktopManager.plasma6.enable = true;
            displayManager.sddm = {
              enable = true;
              wayland.enable = true;
            };
            lact.enable = true;
          };

          services.udev.packages = with pkgs; [
            vial
          ];

          # =====================================================================
          # Users & Packages Config
          # =====================================================================

          users.users.thomashexton = {
            isNormalUser = true;
            extraGroups = [ "wheel" "networkmanager" ];
            shell = pkgs.fish;
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAWmZ5MK+XXYlgK7u7RrRxZAThUFN6DUjbcWBBTZ5Pxr hxtn"
            ];
            packages = with pkgs; [
            ];
          };

          environment.systemPackages = with pkgs; [
            alacritty
            fish
            fishPlugins.autopair
            fishPlugins.done
            fishPlugins.z
            git
            bottles
            unstable.faugus-launcher
            ghostty
            unstable.goverlay
            lutris
            unstable.mangohud
            mesa-demos
            nixd
            protontricks
            nixfmt-rfc-style
            nodejs_20
            pavucontrol
            tree
            vial
            vim
            vulkan-tools
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

            rsi-launcher = {
              enable = true;
              umu.enable = true;
              preCommands = ''
                export MANGOHUD=1
                export MANGOHUD_CONFIG=read_cfg
              '';
            };

            fish.enable = true;
          };

          # A module function of its own so `lib` is home-manager's extended
          # lib (lib.hm.dag below).
          home-manager.users.thomashexton =
            { lib, pkgs, ... }:
            {
              imports = with config.flake.modules.homeManager; [
              codex
              git
              tmux
              zed
            ];

            home.packages = with pkgs; [
              unstable.codex
              discord
              just
              mcp-nixos
              tmux
              wowup-cf
              inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight
            ];

            # # Deskflow autostart (KDE system tray)
            # xdg.configFile."autostart/org.deskflow.deskflow.desktop".text = ''
            #   [Desktop Entry]
            #   Categories=Utility;
            #   Comment=Mouse and keyboard sharing utility
            #   Exec=deskflow
            #   Icon=org.deskflow.deskflow
            #   Keywords=keyboard;mouse;sharing;network;share;
            #   Name=Deskflow
            #   Terminal=false
            #   Type=Application
            # '';

            home.activation.plasmaKeyboardRepeat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Keyboard --key RepeatDelay 200
              ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Keyboard --key RepeatRate 40
            '';
          };

          system.stateVersion = "25.05";
        }
      )
    ];
  };
}
