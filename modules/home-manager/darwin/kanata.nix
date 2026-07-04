{ config, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
  kanataBin = "/opt/homebrew/bin/kanata";
  kanataConfigDir = pkgs.linkFarm "kanata-config" [
    {
      name = "kanata.kbd";
      path = pkgs.writeText "kanata.kbd" ''
        ;; Repo-managed kanata config for macOS.
        ;; Karabiner remains installed only to provide the VirtualHID driver.

        (defcfg
          process-unmapped-keys no
          macos-dev-names-exclude (
            "Charybdis Nano (3x5) Splinky"
            "endgame"
            "2.4g REC"
          )
        )

        ;; caps lock: tap = escape, hold = left control
        (defalias
          cap (tap-hold 200 200 esc lctl)
        )

        (defsrc
          f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          caps a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lalt lmet           spc            rmet ralt
        )

        (deflayer base
          brdn brup _    _    _    _    prev pp   next mute vold volu
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          @cap a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lalt lmet           spc            ralt rmet
        )
      '';
    }
  ];
  kanataConfig = "${homeDir}/.config/kanata/kanata.kbd";
in
{
  xdg.configFile."kanata" = {
    source = kanataConfigDir;
    force = true;
  };

  home.packages = [
    (pkgs.writeShellScriptBin "kanata-check" ''
      set -euo pipefail

      KANATA_BIN="''${KANATA_BIN:-${kanataBin}}"
      KANATA_CONFIG="''${KANATA_CONFIG:-${kanataConfig}}"

      if [[ ! -x "''${KANATA_BIN}" ]]; then
        echo "kanata binary not found at ''${KANATA_BIN}" >&2
        exit 1
      fi

      if [[ ! -f "''${KANATA_CONFIG}" ]]; then
        echo "kanata config not found at ''${KANATA_CONFIG}" >&2
        exit 1
      fi

      exec "''${KANATA_BIN}" --check --cfg "''${KANATA_CONFIG}"
    '')
    (pkgs.writeShellScriptBin "kanata-start" ''
      set -euo pipefail

      KANATA_BIN="''${KANATA_BIN:-${kanataBin}}"
      KANATA_CONFIG="''${KANATA_CONFIG:-${kanataConfig}}"

      if [[ ! -x "''${KANATA_BIN}" ]]; then
        echo "kanata binary not found at ''${KANATA_BIN}" >&2
        exit 1
      fi

      if [[ ! -f "''${KANATA_CONFIG}" ]]; then
        echo "kanata config not found at ''${KANATA_CONFIG}" >&2
        exit 1
      fi

      exec sudo "''${KANATA_BIN}" --cfg "''${KANATA_CONFIG}"
    '')
    (pkgs.writeShellScriptBin "kanata-reload-service" ''
      set -euo pipefail

      readonly KANATA_PLIST="/Library/LaunchDaemons/com.thomashexton.kanata.plist"
      readonly KANATA_SERVICE="system/com.thomashexton.kanata"

      sudo launchctl bootout system "''${KANATA_PLIST}" 2>/dev/null || true
      sudo launchctl bootstrap system "''${KANATA_PLIST}"
      exec sudo launchctl print "''${KANATA_SERVICE}"
    '')
  ];
}
