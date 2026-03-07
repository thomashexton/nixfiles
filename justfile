hostname := shell('hostname -s')

default:
    @just --list

# Apply configuration for the current host
switch:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{hostname}}" in
        work-laptop) darwin-rebuild switch --flake .#work-laptop --show-trace --print-build-logs ;;
        mac-mini)    darwin-rebuild switch --flake .#mac-mini --show-trace --print-build-logs ;;
        hxtn)        sudo nixos-rebuild switch --flake .#hxtn --show-trace --print-build-logs ;;
        *)           echo "Unknown host: {{hostname}}" && exit 1 ;;
    esac

# Apply config without updating bootloader (NixOS only — good for testing)
test:
    sudo nixos-rebuild test --flake .#hxtn --show-trace --print-build-logs

# Build a host's config without activating it
validate host:
    nix build -L .#nixosConfigurations.{{host}}.config.system.build.toplevel

# Update all flake inputs
update:
    nix flake update

# Check flake without switching
check:
    nix flake check
