{
  home.personal =
    { lib, pkgs, ... }:
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
      '';
    };
}
