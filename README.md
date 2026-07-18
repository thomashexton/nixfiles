# nixfiles

NixOS and nix-darwin system configurations managed with flakes and Home Manager.

## Mental Model

- Every automatically imported `.nix` file under `modules/` is a top-level
  flake-parts module implementing one feature.
- Feature files merge their NixOS, nix-darwin, and Home Manager contributions
  into capability profiles such as `desktop`, `gaming`, and `canva`.
- `modules/hosts/` contains thin host constructors that select system
  capabilities and retain only machine identity and hardware-specific values.
- Files beginning with `_` are excluded from automatic imports; generated
  hardware configuration is the intentional exception.
- On macOS, install Nix first, then let this repo manage the machine with `nix-darwin`.
- On NixOS, Nix is already part of the OS, so this repo can manage the whole machine directly.
- Home Manager is embedded in the host builds here. Do not use `home-manager switch` for this repo.

## Hosts

| Host | OS | Arch | Description |
|------|-----|------|-------------|
| `hxtn` | NixOS | x86_64-linux | Desktop (AMD, KDE Plasma 6) |
| `mac-mini` | macOS | aarch64-darwin | Personal Mac Mini |
| `macbook-pro` | macOS | aarch64-darwin | Work MacBook Pro |

## Dendritic Architecture

The repository uses the [Dendritic pattern](https://github.com/mightyiam/dendritic)
with flake-parts and import-tree. Lower-level modules are stored in three
top-level configuration classes:

- `home.*` — Home Manager capabilities
- `darwin.*` — nix-darwin system capabilities
- `nixos.*` — NixOS system capabilities

Features merge into a small set of stable profiles. System profiles compose the
matching Home Manager profiles, so host files do not maintain per-feature Home
Manager import lists.

- `mac-mini`: `darwin.base` + `darwin.desktop`
- `macbook-pro`: `darwin.base` + `darwin.canva`
- `hxtn`: `nixos.base` + `nixos.desktop` + `nixos.gaming` +
  `nixos.deskflowServer` + `nixos.remoteAccess`

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
just fmt               # format Nix files
just fmt-check         # verify Nix formatting without rewriting files
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

1. Create a top-level host module under `modules/hosts/`.
2. Select existing system capabilities for the host.
3. Keep only hostname, state version, and genuinely machine-specific hardware
   values in the host constructor.
4. Add reusable behavior to a feature module and merge it into a capability
   profile rather than extending host import lists.
5. Validate the new host before switching.

Prefer host names that describe the machine, and express role through imported
modules.

- Good pattern: `mac-mini`, `macbook-pro`, `devbox`
- Role/purpose: `personal`, `work`, `server`

If the future devbox is macOS or NixOS, it fits this host model directly. If it
is a non-NixOS Linux machine, the repo will probably need a separate
standalone-Home-Manager target rather than another `nixosConfigurations` or
`darwinConfigurations` entry.

## Notes

### Config ownership

This repo does not treat every file under `~/.config` or `~/.claude` as the
same kind of thing.

Use this rule:

- If Home Manager has a clear native module and the setting is declarative, use
  typed Nix options.
- If the file is still declarative but the app's native format is clearer, keep
  it in Nix as a raw file.
- If the file needs to stay writable at its canonical path, or the app is
  expected to rewrite it itself, keep the link managed by Home Manager but
  point it at a mutable file in this repo with `mkOutOfStoreSymlink`.

In practice, that means:

- Typed Nix: `git`, `tmux`, `aerospace`
- Store-backed raw files: `zsh`, `~/.claude/statusline-command.sh`, and the
  Canva-specific `CLAUDE.md`
- Out-of-store files: `~/.codex/config.toml`, `~/.claude/settings.json`,
  `~/.config/alacritty/alacritty.toml`, and Karabiner's JSON configuration

The important distinction is config versus state:

- Declarative config should be repo-authored and reproducible.
- Files that need to stay writable at their canonical path should not be
  frozen into the Nix store, or the next `just switch` will put the declared
  version back.

For out-of-store files in this repo, the home-directory path becomes a symlink
to a real file in `~/nixfiles`, not to `/nix/store`. That means edits at the
home-directory path, including writes made by the app itself, update the repo
file directly. Home Manager manages the symlink; the repo file remains the
source of truth.

### Home Manager in this repo

This repo does use Home Manager, but not in standalone mode.

- On macOS, Home Manager is embedded in the `nix-darwin` system build.
- On NixOS, Home Manager is embedded in the `nixos-rebuild` system build.
- That means the normal apply commands are `just switch`, `darwin-rebuild switch`, or `nixos-rebuild switch`.
- Do not use `home-manager switch` for this repo.

Home Manager configuration is composed through the `home.*` capability
profiles. The `darwin.*` and `nixos.*` system profiles import the appropriate
home profiles for each host.

### Flakes and experimental features

This repo expects `nix-command` and `flakes` to be enabled.

- On `mac-mini`, Determinate Nix already enables them as part of the Nix install.
- On `hxtn`, they are enabled by the shared `nixos.base` capability.
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
