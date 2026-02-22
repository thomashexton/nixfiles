# nixfiles

NixOS and nix-darwin system configurations managed with flakes and home-manager.

## Hosts

| Host | OS | Arch | Description |
|------|-----|------|-------------|
| `hxtn` | NixOS | x86_64-linux | Desktop (AMD, Hyprland) |
| `mac-mini` | macOS | aarch64-darwin | Personal Mac Mini |
| `work-laptop` | macOS | aarch64-darwin | Work MacBook Pro |

## Setup

The config lives in `~/nix-config` and is symlinked to `/etc/nixos`:

```bash
sudo mv /etc/nixos ~/nix-config
sudo ln -s /home/thomashexton/nix-config /etc/nixos
```

## Usage

```bash
# Build without switching
rb

# Build and switch
rb-switch

# Build and test (switch without adding boot entry)
rb-test

# Update flake inputs
update
```
