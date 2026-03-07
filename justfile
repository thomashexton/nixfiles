default:
    @just --list

# Apply configuration for the current host
switch:
    #!/usr/bin/env bash
    set -euo pipefail
    case "$(hostname -s)" in
        work-laptop) darwin-rebuild switch --flake .#work-laptop ;;
        mac-mini)    darwin-rebuild switch --flake .#mac-mini ;;
        hxtn)        sudo nixos-rebuild switch --flake .#hxtn ;;
        *)           echo "Unknown host: $(hostname -s)" && exit 1 ;;
    esac

# Update all flake inputs
update:
    nix flake update

# Check flake without switching
check:
    nix flake check
