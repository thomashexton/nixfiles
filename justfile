hostname := shell('hostname -s')

default:
    @just --list

# Apply configuration for the current host
switch:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{hostname}}" in
        macbook-pro) sudo darwin-rebuild switch --flake .#macbook-pro --show-trace --print-build-logs ;;
        mac-mini)    sudo darwin-rebuild switch --flake .#mac-mini --show-trace --print-build-logs ;;
        hxtn)        sudo nixos-rebuild switch --flake .#hxtn --show-trace --print-build-logs ;;
        *)           echo "Unknown host: {{hostname}}" && exit 1 ;;
    esac

# Apply config without updating bootloader (NixOS only — good for testing)
test:
    sudo nixos-rebuild test --flake .#hxtn --show-trace --print-build-logs

# Build a host's config without activating it
validate host:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{host}}" in
        hxtn)        nix build -L .#nixosConfigurations.{{host}}.config.system.build.toplevel ;;
        macbook-pro) nix build -L .#darwinConfigurations.{{host}}.system ;;
        mac-mini)    nix build -L .#darwinConfigurations.{{host}}.system ;;
        *)           echo "Unknown host: {{host}}" && exit 1 ;;
    esac

# Bootstrap nix-darwin on a fresh macOS install (darwin-rebuild not yet available)
bootstrap host:
    sudo nix run "github:nix-darwin/nix-darwin/nix-darwin-25.11#darwin-rebuild" -- \
      switch --flake .#{{host}} --show-trace --print-build-logs

# Update all flake inputs
update:
    nix flake update

# Check flake without switching
check:
    nix flake check
