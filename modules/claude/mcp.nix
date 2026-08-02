let
  # Python rejects the Proxmox cluster CA, so pin the node certificate until
  # it uses a publicly trusted certificate. The pinned leaf expires 2028-01-12.
  proxmoxCaBundle =
    pkgs:
    pkgs.runCommand "proxmox-ca-bundle.pem" { } ''
      cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ${./minilab-pve-leaf.pem} > $out
    '';
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
      # Secrets stay in 1Password; op run substitutes these at launch.
      opItem = "op://Homelab/Proxmox Host - minilab - Claude MCP";
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
        # Pin Nix Python because GUI clients do not inherit the Nix profile PATH.
        if ! ${pkgs.jq}/bin/jq -e '.mcpServers.proxmox' "$claude_config" >/dev/null 2>&1; then
          $DRY_RUN_CMD ${pkgs.unstable.claude-code}/bin/claude mcp add \
            --transport stdio \
            --scope user \
            proxmox \
            -e "PROXMOX_HOST=minilab.hxtn.net" \
            -e "PROXMOX_PORT=8006" \
            -e "PROXMOX_SERVICE=PVE" \
            -e "PROXMOX_USER=claude@pve" \
            -e "PROXMOX_TOKEN_NAME=mcp" \
            -e "PROXMOX_TOKEN_VALUE=${opItem}/credential" \
            -e "PROXMOX_VERIFY_SSL=true" \
            -e "PROXMOX_DEV_MODE=false" \
            -e "REQUESTS_CA_BUNDLE=/etc/codex/proxmox-ca-bundle.pem" \
            -e "LOG_LEVEL=INFO" \
            -e "PROXMOX_JOBS_SQLITE_PATH=:memory:" \
            -e "COMMAND_POLICY_MODE=deny_all" \
            -e "COMMAND_POLICY_HIGH_RISK_MODE=enforce" \
            -e "COMMAND_POLICY_HIGH_RISK_REQUIRE_APPROVAL_TOKEN=true" \
            -e "COMMAND_POLICY_HIGH_RISK_APPROVAL_TOKEN=${opItem}/high_risk_approval_token" \
            -- \
            op run -- \
            uvx --python ${pkgs.python3}/bin/python3 proxmox-mcp-plus@0.5.12
        fi
      '';
    };
}
