let
  # Python rejects the Proxmox cluster CA, so pin the node certificate until
  # it uses a publicly trusted certificate. The pinned leaf expires 2028-01-12.
  proxmoxCaBundle =
    pkgs:
    pkgs.runCommand "proxmox-ca-bundle.pem" { } ''
      cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ${./minilab-pve-leaf.pem} > $out
    '';

  # Secrets stay in 1Password; op run substitutes these at launch.
  opItem = "op://Homelab/Proxmox Host - minilab - Claude MCP";

  # Claude Code and Claude Desktop read separate MCP configuration files.
  proxmoxEnv = {
    PROXMOX_HOST = "minilab.hxtn.net";
    PROXMOX_PORT = "8006";
    PROXMOX_SERVICE = "PVE";
    PROXMOX_USER = "claude@pve";
    PROXMOX_TOKEN_NAME = "mcp";
    PROXMOX_TOKEN_VALUE = "${opItem}/credential";
    PROXMOX_VERIFY_SSL = "true";
    PROXMOX_DEV_MODE = "false";
    REQUESTS_CA_BUNDLE = "/etc/codex/proxmox-ca-bundle.pem";
    LOG_LEVEL = "INFO";
    # Avoid creating job state in the client's working directory.
    PROXMOX_JOBS_SQLITE_PATH = ":memory:";
    COMMAND_POLICY_MODE = "deny_all";
    COMMAND_POLICY_HIGH_RISK_MODE = "enforce";
    COMMAND_POLICY_HIGH_RISK_REQUIRE_APPROVAL_TOKEN = "true";
    COMMAND_POLICY_HIGH_RISK_APPROVAL_TOKEN = "${opItem}/high_risk_approval_token";
  };
in
{
  darwin.personal =
    { pkgs, ... }:
    {
      environment.etc."codex/proxmox-ca-bundle.pem".source = proxmoxCaBundle pkgs;
    };

  nixos.personal =
    { pkgs, ... }:
    {
      environment.etc."codex/proxmox-ca-bundle.pem".source = proxmoxCaBundle pkgs;
    };

  home.personal =
    { lib, pkgs, ... }:
    let
      # GUI clients need store paths and Nix Python for the pinned certificate.
      proxmoxServer = {
        command = "${pkgs.unstable._1password-cli}/bin/op";
        args = [
          "run"
          "--"
          "${pkgs.uv}/bin/uvx"
          "--python"
          "${pkgs.python3}/bin/python3"
          "proxmox-mcp-plus@0.5.12"
        ];
        env = proxmoxEnv;
      };

      proxmoxServerJson = pkgs.writeText "proxmox-mcp-server.json" (builtins.toJSON proxmoxServer);

      envFlags = lib.concatStringsSep " \\\n            " (
        lib.mapAttrsToList (k: v: "-e ${lib.escapeShellArg (k + "=" + v)}") proxmoxEnv
      );
    in
    {
      home.activation.claudeMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        claude_config="$HOME/.claude.json"

        if ! ${pkgs.jq}/bin/jq -e '.mcpServers.pocketsmith' "$claude_config" >/dev/null 2>&1; then
          $DRY_RUN_CMD ${pkgs.unstable.claude-code}/bin/claude mcp add \
            --transport http \
            --scope user \
            pocketsmith \
            https://mcp-readonly.pocketsmith.com/mcp
        fi

        if ! ${pkgs.jq}/bin/jq -e '.mcpServers["unifi-network"]' "$claude_config" >/dev/null 2>&1; then
          $DRY_RUN_CMD ${pkgs.unstable.claude-code}/bin/claude mcp add \
            --transport stdio \
            --scope user \
            unifi-network \
            -e "UNIFI_NETWORK_HOST=192.168.10.1" \
            -e "UNIFI_NETWORK_USERNAME=op://Private/UniFi Network/username" \
            -e "UNIFI_NETWORK_PASSWORD=op://Private/UniFi Network/password" \
            -e "UNIFI_NETWORK_VERIFY_SSL=false" \
            -- \
            op run -- \
            uvx --python-preference system unifi-network-mcp@0.24.1
        fi

        # Proxmox RBAC is authoritative; this token must remain PVEAuditor-only.
        # Converge existing registrations so rebuilds replace stale store paths.
        proxmox_desired=$(${pkgs.jq}/bin/jq -Sc '{command, args, env}' ${proxmoxServerJson})
        proxmox_current=$(${pkgs.jq}/bin/jq -Sc \
          '.mcpServers.proxmox | if . == null then null else {command, args, env} end' \
          "$claude_config" 2>/dev/null || echo null)

        if [ "$proxmox_current" != "$proxmox_desired" ]; then
          $DRY_RUN_CMD ${pkgs.unstable.claude-code}/bin/claude mcp remove proxmox -s user >/dev/null 2>&1 || true
          $DRY_RUN_CMD ${pkgs.unstable.claude-code}/bin/claude mcp add \
            --transport stdio \
            --scope user \
            proxmox \
            ${envFlags} \
            -- \
            ${proxmoxServer.command} run -- \
            ${pkgs.uv}/bin/uvx --python ${pkgs.python3}/bin/python3 proxmox-mcp-plus@0.5.12
        fi
      '';

      # Merge into Claude Desktop's app-owned config without replacing other settings.
      home.activation.claudeDesktopMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        desktop_dir="$HOME/Library/Application Support/Claude"
        desktop_config="$desktop_dir/claude_desktop_config.json"

        if [ -d "$desktop_dir" ]; then
          if [ ! -f "$desktop_config" ]; then
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 600 \
              ${pkgs.writeText "claude-desktop-config-empty.json" "{}"} "$desktop_config"
          fi

          desktop_tmp=$(${pkgs.coreutils}/bin/mktemp)
          if ${pkgs.jq}/bin/jq --slurpfile server ${proxmoxServerJson} \
               '.mcpServers.proxmox = $server[0]' "$desktop_config" > "$desktop_tmp"; then
            $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 600 "$desktop_tmp" "$desktop_config"
          else
            echo "claude_desktop_config.json is not valid JSON; leaving it alone" >&2
          fi
          ${pkgs.coreutils}/bin/rm -f "$desktop_tmp"
        fi
      '';
    };
}
