# nixfiles

NixOS and nix-darwin system configurations managed with flakes and home-manager.

## Hosts

| Host | OS | Arch | Description |
|------|-----|------|-------------|
| `hxtn` | NixOS | x86_64-linux | Desktop (AMD, KDE Plasma 6) |
| `mac-mini` | macOS | aarch64-darwin | Personal Mac Mini |
| `work-laptop` | macOS | aarch64-darwin | Work MacBook Pro |

## Setup

The config lives in `~/nixfiles` and is symlinked to `/etc/nixos`:

```bash
sudo mv /etc/nixos ~/nixfiles
sudo ln -s /home/thomashexton/nixfiles /etc/nixos
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

## Notes

### Why KDE Plasma instead of Hyprland?

Deskflow KVM (used to share mouse/keyboard between hxtn and the Macs) requires the
[InputCapture](https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.InputCapture.html)
XDG Desktop Portal, which KDE Plasma 6.1+ implements but Hyprland does not yet.

Hyprland tracking issue: [xdg-desktop-portal-hyprland#259](https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/259)
Draft PR: [xdg-desktop-portal-hyprland#268](https://github.com/hyprwm/xdg-desktop-portal-hyprland/pull/268)

If Hyprland merges InputCapture support, switching back is an option — the old config is in git history.
