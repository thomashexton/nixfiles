# nixfiles

NixOS and nix-darwin system configurations managed with flakes and Home Manager.

## Hosts

| Host | OS | Arch | Description |
|------|-----|------|-------------|
| `hxtn` | NixOS | x86_64-linux | Desktop (AMD, KDE Plasma 6) |
| `mac-mini` | macOS | aarch64-darwin | Personal Mac Mini |
| `work-laptop` | macOS | aarch64-darwin | Work MacBook Pro |

## Current State

- Nix is installed on `mac-mini` via Determinate Nix.
- `nix-darwin` is defined in this repo, but `darwin-rebuild` is not available until the first Darwin activation.
- Until that first activation, use plain `nix build` or `nix run` for validation.
- The existing `~/dotfiles` bootstrap/stow setup remains the rollback path while macOS migration is incremental.

## macOS Bootstrap

### 1. Install Nix

If Nix is not already installed, install Determinate Nix:

```bash
curl --proto '=https' --tlsv1.2 -fsSL https://install.determinate.systems/nix \
  | sh -s -- install
```

Open a new shell after installation.

### 2. Clone the repo

```bash
git clone git@github.com:thomashexton/nixfiles.git ~/nixfiles
cd ~/nixfiles
```

### 3. Validate before switching

If `just` is not on `PATH` yet, run it through Nix:

```bash
nix run nixpkgs#just -- validate mac-mini
nix flake check
```

### 4. First nix-darwin activation

Bootstrap `nix-darwin` with a one-off `nix run`:

```bash
sudo nix run github:nix-darwin/nix-darwin/nix-darwin-25.11#darwin-rebuild -- \
  switch --flake ~/nixfiles#mac-mini
```

After the first successful switch, `darwin-rebuild` should be available for normal use.

## NixOS Bootstrap

On `hxtn`, keep the repo at `~/nixfiles` and point `/etc/nixos` at it:

```bash
sudo mv /etc/nixos ~/nixfiles
sudo ln -s /home/thomashexton/nixfiles /etc/nixos
```

Then apply:

```bash
sudo nixos-rebuild switch --flake ~/nixfiles#hxtn
```

## Usage

```bash
just switch            # apply config for the current host
just test              # NixOS only: apply without updating bootloader
just validate mac-mini # build a host config without activating it
just update            # bump flake inputs
just check             # run flake checks
```

If `just` is not installed yet:

```bash
nix run nixpkgs#just -- validate mac-mini
nix run nixpkgs#just -- check
```

## Notes

### How macOS is working right now

On `mac-mini`, Nix itself is already installed by Determinate Nix. The `nix`
binary is coming from `/nix/var/nix/profiles/default/bin/nix`, with config in
`/etc/nix/nix.conf`. That install currently provides:

- the `nix` CLI
- the `nix-daemon`
- Determinate cache/substituter settings

It does not yet provide `darwin-rebuild`, because this machine has not been
switched to the nix-darwin config yet.

### Why KDE Plasma instead of Hyprland?

Deskflow KVM (used to share mouse/keyboard between `hxtn` and the Macs)
requires the
[InputCapture](https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.InputCapture.html)
XDG Desktop Portal, which KDE Plasma 6.1+ implements but Hyprland does not yet.

Hyprland tracking issue: [xdg-desktop-portal-hyprland#259](https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/259)
Draft PR: [xdg-desktop-portal-hyprland#268](https://github.com/hyprwm/xdg-desktop-portal-hyprland/pull/268)

If Hyprland merges InputCapture support, switching back is an option. The old
config is in git history.
