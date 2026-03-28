{ config, lib, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  home.file.".codex/config.toml" = {
    force = true;
    text = ''
      model = "gpt-5.4"
      model_reasoning_effort = "xhigh"
      sandbox_mode = "workspace-write"
      approval_policy = "on-request"

      [projects."${homeDir}"]
      trust_level = "trusted"

      [projects."${homeDir}/nixfiles"]
      trust_level = "trusted"

      [sandbox_workspace_write]
      network_access = true

      [features]
      multi_agent = true

      [plugins."github@openai-curated"]
      enabled = true

      [mcp_servers.nixos]
      command = "${lib.getExe pkgs.mcp-nixos}"

      [mcp_servers.nixos.tools.darwin_search]
      approval_mode = "approve"

      [mcp_servers.nixos.tools.home_manager_options_by_prefix]
      approval_mode = "approve"

      [mcp_servers.nixos.tools.darwin_options_by_prefix]
      approval_mode = "approve"

      [mcp_servers.nixos.tools.home_manager_info]
      approval_mode = "approve"

      [mcp_servers.nixos.tools.darwin_info]
      approval_mode = "approve"

      [mcp_servers.nixos.tools.nixos_search]
      approval_mode = "approve"

      [mcp_servers.nixos.tools.nixos_info]
      approval_mode = "approve"
    '';
  };
}
