{
  home.base =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.unstable.codex
        pkgs.mcp-nixos
      ];
    };

  # Keep shared MCP definitions below Codex's writable, per-device user config.
  darwin.base.environment.etc."codex/config.toml".source = ./config.toml;
  nixos.base.environment.etc."codex/config.toml".source = ./config.toml;
}
