{ config, inputs, ... }:

let
  hyprlandHome = config.home.hyprland;
in
{
  nixos.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      hyprlandPackages = inputs.hyprland.packages.${system};
      hyprlandNixpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
    in
    {
      home-manager.users.thomashexton.imports = [ hyprlandHome ];

      # XDPH requires the compositor and portal built together by Hyprland's flake.
      programs.hyprland = {
        enable = true;
        package = hyprlandPackages.hyprland;
        portalPackage = hyprlandPackages.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
      };

      # Hyprland's package is built against its own nixpkgs revision. Matching
      # Mesa avoids the client/driver mismatch warned about by upstream when a
      # stable NixOS configuration consumes the Hyprland flake.
      hardware.graphics = {
        package = hyprlandNixpkgs.mesa;
        package32 = hyprlandNixpkgs.pkgsi686Linux.mesa;
      };

      nix.settings = {
        substituters = lib.mkAfter [ "https://hyprland.cachix.org" ];
        trusted-public-keys = lib.mkAfter [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-user-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
          user = "greeter";
        };
      };

      networking.networkmanager.enable = true;
      programs.firefox.enable = true;
      security.polkit.enable = true;

      environment.systemPackages = with pkgs; [
        brightnessctl
        fuzzel
        ghostty
        hyprpolkitagent
        kdePackages.dolphin
        pavucontrol
        playerctl
        wdisplays
      ];
    };

  home.hyprland =
    { lib, pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      xdph = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
      xdphExecutable = "${xdph}/libexec/.xdg-desktop-portal-hyprland-wrapped";
    in
    {
      home.packages = [
        inputs.zen-browser.packages.${system}.twilight
      ];

      # Avoid a second Home Manager package pair; NixOS selects the matched pair above.
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd.enable = true;

        settings = {
          monitor = [ "HDMI-A-1,preferred,auto,auto" ];

          "$terminal" = "ghostty";
          "$fileManager" = "dolphin";
          "$menu" = "fuzzel";
          "$mainMod" = "SUPER";

          exec-once = [
            "waybar"
            "hyprpolkitagent"
            "steam -silent"
            "zen"
            "deskflow"
          ];

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
          ];

          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };

          decoration = {
            rounding = 0;
            active_opacity = 1.0;
            inactive_opacity = 0.8;
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };
            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };
          };

          animations.enabled = false;
          dwindle.preserve_split = true;

          misc = {
            force_default_wallpaper = -1;
            disable_hyprland_logo = false;
          };

          input = {
            kb_layout = "us";
            repeat_delay = 200;
            repeat_rate = 40;
            follow_mouse = 0;
            sensitivity = 0.0;
            accel_profile = "flat";
            touchpad.natural_scroll = false;
          };

          # Deskflow needs modifier events as well as pointer/ordinary-key
          # events. Invalid portal barriers should fail rather than capturing
          # at an unexpected edge.
          "input-capture" = {
            capture_modifiers = true;
            enforce_barriers = true;
          };

          # Permission enforcement is optional upstream. Enabling it with an
          # exact allow rule keeps InputCapture restricted to the pinned XDPH
          # executable instead of granting it to arbitrary Wayland clients.
          ecosystem.enforce_permissions = true;
          permission = [
            "${lib.escapeRegex xdphExecutable}, input-capture, allow"
            "${lib.escapeRegex xdphExecutable}, screencopy, allow"
          ];

          bind = [
            "$mainMod, Return, exec, $terminal"
            "$mainMod, Q, killactive,"
            "$mainMod, F, exec, $fileManager"
            "ALT, F, togglefloating,"
            "$mainMod, R, exec, $menu"
            "$mainMod, J, layoutmsg, togglesplit"

            "$mainMod CTRL, J, movefocus, l"
            "$mainMod CTRL, L, movefocus, r"
            "$mainMod CTRL, I, movefocus, u"
            "$mainMod CTRL, K, movefocus, d"

            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
            "$mainMod, D, exec, wdisplays"
          ];

          # The x flag keeps this escape hatch available while Deskflow owns
          # input. Super+Shift+Escape forcibly returns control to hxtn.
          bindx = [
            "$mainMod SHIFT, Escape, releaseinputcapture,"
          ];

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          bindel = [
            ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
            ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
          ];

          bindl = [
            ",XF86AudioNext, exec, playerctl next"
            ",XF86AudioPause, exec, playerctl play-pause"
            ",XF86AudioPlay, exec, playerctl play-pause"
            ",XF86AudioPrev, exec, playerctl previous"
          ];
        };
      };

      programs.waybar = {
        enable = true;
        systemd.enable = false;
        settings.mainBar = {
          position = "top";
          height = 30;
          spacing = 4;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [
            "pulseaudio"
            "network"
            "tray"
          ];

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              active = "●";
              default = "○";
              urgent = "!";
            };
          };

          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%Y-%m-%d}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          pulseaudio = {
            format = "{volume}%";
            format-bluetooth = "{volume}%";
            format-muted = "muted";
            on-click = "pavucontrol";
          };

          network = {
            format-wifi = "{essid} ({signalStrength}%)";
            format-ethernet = "{ifname}: {ipaddr}/{cidr}";
            format-disconnected = "Disconnected";
            tooltip-format = "{ifname}: {ipaddr}";
          };
        };

        style = ''
          * {
            border: none;
            border-radius: 0;
            font-family: "JetBrains Mono", monospace;
            font-size: 13px;
            min-height: 0;
          }

          window#waybar {
            background: rgba(43, 48, 59, 0.5);
            border-bottom: 3px solid rgba(100, 114, 125, 0.5);
            color: white;
          }

          #workspaces button {
            padding: 0 5px;
            background: transparent;
            color: white;
            border-bottom: 3px solid transparent;
          }

          #workspaces button.active {
            background: #64727d;
            border-bottom: 3px solid white;
          }

          #clock, #network, #pulseaudio, #tray {
            padding: 0 10px;
            margin: 0 5px;
          }
        '';
      };
    };
}
