{
  darwin.base.environment.etc."codex/config.toml".text = builtins.readFile ./config.toml;
  nixos.base.environment.etc."codex/config.toml".text = builtins.readFile ./config.toml;

  home.base =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.unstable.codex
        pkgs.mcp-nixos
      ];
    };
}
