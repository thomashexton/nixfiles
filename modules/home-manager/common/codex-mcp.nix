{ config, lib, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
  codexHome = "${homeDir}/.codex";
  codexCandidates = [
    "${homeDir}/.nix-profile/bin/codex"
    "/etc/profiles/per-user/${config.home.username}/bin/codex"
    "/opt/homebrew/bin/codex"
  ];
in
{
  home.activation.codexMcpNixos = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export HOME=${lib.escapeShellArg homeDir}
    export CODEX_HOME=${lib.escapeShellArg codexHome}

    codex_bin=""

    if command -v codex >/dev/null 2>&1; then
      codex_bin="$(command -v codex)"
    else
      for candidate in ${lib.concatStringsSep " " (map lib.escapeShellArg codexCandidates)}; do
        if [ -x "$candidate" ]; then
          codex_bin="$candidate"
          break
        fi
      done
    fi

    if [ -z "$codex_bin" ]; then
      echo "codex not found; skipping nixos MCP registration" >&2
    else
      mkdir -p "$CODEX_HOME"

      if ! "$codex_bin" mcp add nixos -- ${lib.escapeShellArg (lib.getExe pkgs.mcp-nixos)} >/dev/null; then
        echo "warning: failed to register nixos MCP server for Codex" >&2
      fi
    fi
  '';
}
