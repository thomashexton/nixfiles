# nixfiles

NixOS and nix-darwin system configurations managed with flakes and Home Manager.

## Mental Model

- `hosts/<name>/configuration.nix` is system-level config.
- `hosts/<name>/home.nix` is user-level config via Home Manager.
- `modules/` contains shared building blocks.
- On macOS, install Nix first, then let this repo manage the machine with `nix-darwin`.
- On NixOS, Nix is already part of the OS, so this repo can manage the whole machine directly.
- Home Manager is embedded in the host builds here. Do not use `home-manager switch` for this repo.

## Hosts

| Host | OS | Arch | Description |
|------|-----|------|-------------|
| `hxtn` | NixOS | x86_64-linux | Desktop (AMD, KDE Plasma 6) |
| `mac-mini` | macOS | aarch64-darwin | Personal Mac Mini |
| `macbook-pro` | macOS | aarch64-darwin | Work MacBook Pro |

## Current State

- Nix is installed on `mac-mini` via Determinate Nix.
- On macOS hosts using Determinate, nix-darwin imports Determinate's Darwin module and sets `determinateNix.enable = true;`.
- `mac-mini` has already had its first Darwin activation, so `darwin-rebuild` is available there now.
- On a fresh macOS host, `darwin-rebuild` is not available until the first Darwin activation; use `just bootstrap <host>` which handles this via `nix run`.
- The existing `~/dotfiles` bootstrap/stow setup remains the rollback path while macOS migration is incremental.

## Fresh macOS Setup

Use this for a new Mac.

### 1. Install Nix first

This repo does not install Nix from nothing. On macOS, install Determinate Nix first:

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
nix run nixpkgs#just -- validate macbook-pro
nix flake check
```

### 4. First nix-darwin activation

`darwin-rebuild` is not installed until after the first activation. Use the
`just bootstrap` recipe, passing your host name:

```bash
cd ~/nixfiles
nix run nixpkgs#just -- bootstrap macbook-pro   # work MacBook Pro
nix run nixpkgs#just -- bootstrap mac-mini      # personal Mac Mini
```

This also sets the machine's hostname via `networking.hostName` in the config,
so it will match the flake name after activation.

After the first successful switch, normal day-to-day usage is:

```bash
cd ~/nixfiles
just switch
```

## Fresh NixOS Setup

Use this for a NixOS machine such as `hxtn`.

### 1. Clone the repo

```bash
git clone git@github.com:thomashexton/nixfiles.git ~/nixfiles
cd ~/nixfiles
```

### 2. Validate and switch

```bash
nix flake check
sudo nixos-rebuild switch --flake ~/nixfiles#hxtn
```

If you want the traditional `/etc/nixos` path to point at this repo, make that
an extra convenience step, not a prerequisite:

```bash
sudo ln -sfn /home/thomashexton/nixfiles /etc/nixos
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

On macOS, `just switch` runs `sudo darwin-rebuild switch ...` under the hood.
On NixOS, it runs `sudo nixos-rebuild switch ...`.

## Adding Another Host

If you add another machine later:

1. Create `hosts/<name>/configuration.nix`.
2. Create `hosts/<name>/home.nix`.
3. Wire the host into [flake.nix](/Users/thomashexton/nixfiles/flake.nix).
4. Reuse shared modules from `modules/` rather than copying whole configs.
5. Validate before switching.

Prefer host names that describe the machine, and express role through imported
modules.

- Good pattern: `mac-mini`, `macbook-pro`, `devbox`
- Role/purpose: `personal`, `work`, `server`

If the future devbox is macOS or NixOS, it fits this host model directly. If it
is a non-NixOS Linux machine, the repo will probably need a separate
standalone-Home-Manager target rather than another `nixosConfigurations` or
`darwinConfigurations` entry.

## Notes

### Home Manager in this repo

This repo does use Home Manager, but not in standalone mode.

- On macOS, Home Manager is embedded in the `nix-darwin` system build.
- On NixOS, Home Manager is embedded in the `nixos-rebuild` system build.
- That means the normal apply commands are `just switch`, `darwin-rebuild switch`, or `nixos-rebuild switch`.
- Do not use `home-manager switch` for this repo.

The Home Manager entrypoints are the host home files:

- `hosts/mac-mini/home.nix`
- `hosts/macbook-pro/home.nix`
- `hosts/hxtn/home.nix`

### Flakes and experimental features

This repo expects `nix-command` and `flakes` to be enabled.

- On `mac-mini`, Determinate Nix already enables them as part of the Nix install.
- On `hxtn`, they are enabled in [configuration.nix](/Users/thomashexton/nixfiles/hosts/hxtn/configuration.nix).
- If you try to use this repo on another machine with a plain Nix install, you may need to enable them first in `nix.conf`.

### How macOS is working right now

On `mac-mini`, Nix itself is already installed by Determinate Nix. The `nix`
binary is coming from `/nix/var/nix/profiles/default/bin/nix`, with config in
`/etc/nix/nix.conf`. That install currently provides:

- the `nix` CLI
- the `nix-daemon`
- Determinate cache/substituter settings

This repo therefore disables nix-darwin’s own Nix installer integration on
macOS by importing Determinate's nix-darwin module and setting
`determinateNix.enable = true;`. On a fresh macOS install, the first
activation still has to bootstrap `darwin-rebuild` via `nix run`.

### Why KDE Plasma instead of Hyprland?

Deskflow KVM (used to share mouse/keyboard between `hxtn` and the Macs)
requires the
[InputCapture](https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.InputCapture.html)
XDG Desktop Portal, which KDE Plasma 6.1+ implements but Hyprland does not yet.

Hyprland tracking issue: [xdg-desktop-portal-hyprland#259](https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/259)
Draft PR: [xdg-desktop-portal-hyprland#268](https://github.com/hyprwm/xdg-desktop-portal-hyprland/pull/268)

If Hyprland merges InputCapture support, switching back is an option. The old
config is in git history.
