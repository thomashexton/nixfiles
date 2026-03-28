{ ... }:

{
  programs.aerospace = {
    enable = true;
    package = null;
    launchd.enable = false;
    userSettings = {
      after-login-command = [ ];
      after-startup-command = [ ];
      start-at-login = true;
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 360;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      key-mapping.preset = "qwerty";

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "secondary";
        "7" = "secondary";
        "8" = "secondary";
        "9" = "secondary";
        "0" = "secondary";
      };

      gaps = {
        inner.horizontal = 0;
        inner.vertical = 0;
        outer.left = 0;
        outer.bottom = 0;
        outer.top = 0;
        outer.right = 0;
      };

      mode = {
        main.binding = {
          "cmd-h" = [ ];
          "cmd-alt-h" = [ ];
          "alt-slash" = "layout tiles horizontal vertical";
          "alt-comma" = "layout accordion horizontal vertical";
          "alt-f" = "layout floating tiling";
          "alt-h" = "focus left";
          "alt-j" = "focus down";
          "alt-k" = "focus up";
          "alt-l" = "focus right";
          "alt-shift-h" = "move left";
          "alt-shift-j" = "move down";
          "alt-shift-k" = "move up";
          "alt-shift-l" = "move right";
          "alt-1" = "workspace 1";
          "alt-2" = "workspace 2";
          "alt-3" = "workspace 3";
          "alt-4" = "workspace 4";
          "alt-5" = "workspace 5";
          "alt-6" = "workspace 6";
          "alt-7" = "workspace 7";
          "alt-8" = "workspace 8";
          "alt-9" = "workspace 9";
          "alt-0" = "workspace 0";
          "alt-shift-1" = "move-node-to-workspace 1";
          "alt-shift-2" = "move-node-to-workspace 2";
          "alt-shift-3" = "move-node-to-workspace 3";
          "alt-shift-4" = "move-node-to-workspace 4";
          "alt-shift-5" = "move-node-to-workspace 5";
          "alt-shift-6" = "move-node-to-workspace 6";
          "alt-shift-7" = "move-node-to-workspace 7";
          "alt-shift-8" = "move-node-to-workspace 8";
          "alt-shift-9" = "move-node-to-workspace 9";
          "alt-shift-0" = "move-node-to-workspace 0";
          "alt-tab" = "workspace-back-and-forth";
          "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";
          "alt-shift-r" = "mode resize";
          "alt-shift-comma" = "mode service";
        };

        resize.binding = {
          h = "resize width -50";
          j = "resize height +50";
          k = "resize height -50";
          l = "resize width +50";
          b = "balance-sizes";
          enter = "mode main";
          esc = "mode main";
        };

        service.binding = {
          esc = [
            "reload-config"
            "mode main"
          ];
          r = [
            "flatten-workspace-tree"
            "mode main"
          ];
          f = [
            "layout floating tiling"
            "mode main"
          ];
          "alt-shift-h" = [
            "join-with left"
            "mode main"
          ];
          "alt-shift-j" = [
            "join-with down"
            "mode main"
          ];
          "alt-shift-k" = [
            "join-with up"
            "mode main"
          ];
          "alt-shift-l" = [
            "join-with right"
            "mode main"
          ];
        };
      };

      on-window-detected = [
        {
          "if".app-id = "com.1password.1password";
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "us.zoom.xos";
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "org.chromium.Chromium";
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "com.wulkano.kap";
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "net.battle.app";
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "com.blizzard.worldofwarcraft";
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "com.markvapps.metadatics";
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "com.Illustrate.dBpoweramp-Music-Converter";
          run = [ "layout floating" ];
        }
        {
          "if" = {
            app-id = "company.thebrowser.Browser";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace 1" ];
        }
        {
          "if" = {
            app-id = "org.alacritty";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace 4" ];
        }
        {
          "if" = {
            app-id = "com.todesktop.230313mzl4w4u92";
            during-aerospace-startup = true;
          };
          run = [ "move-node-to-workspace 5" ];
        }
      ];
    };
  };
}
