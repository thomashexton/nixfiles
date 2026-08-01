{ lib, ... }:

let
  personalConfig = builtins.readFile ./personal.toml;
in
{
  darwin.base.environment.etc."codex/config.toml".text = builtins.readFile ./config.toml;
  darwin.personal.environment.etc."codex/config.toml".text = lib.mkAfter personalConfig;

  nixos.base.environment.etc."codex/config.toml".text = builtins.readFile ./config.toml;
  nixos.personal.environment.etc."codex/config.toml".text = lib.mkAfter personalConfig;

  home.base =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.unstable.codex
        pkgs.mcp-nixos
      ];
    };

  home.personal =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.python3
        pkgs.uv
        pkgs.unstable._1password-cli
      ];
    };
}
