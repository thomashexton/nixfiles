# nixfiles

NixOS and nix-darwin system configurations managed with flakes and Home Manager.

## Mental Model

- Every automatically imported `.nix` file under `modules/` is a top-level
  flake-parts module implementing one feature.
- Feature files merge their NixOS, nix-darwin, and Home Manager contributions
  into capability and role profiles such as `workstation`, `gaming`,
  `personal`, and `professional`.
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
| `hxtn` | NixOS | x86_64-linux | Desktop (AMD, KDE Plasma 6; Hyprland staged) |
| `mac-mini` | macOS | aarch64-darwin | Personal Mac Mini |
| `macbook-pro` | macOS | aarch64-darwin | Work MacBook Pro |

## Configuration Model

The repository uses the [Dendritic pattern](https://github.com/mightyiam/dendritic)
with flake-parts and import-tree. Four kinds of names appear in the
configuration, and they are not interchangeable:

| Kind | Examples | Meaning |
|------|----------|---------|
| Evaluation platform | `aarch64-darwin`, `x86_64-linux` in `config.systems` | Platforms for which flake-parts evaluates `perSystem` outputs such as the formatter. This list does not create hosts or select profiles. |
| Host output | `darwinConfigurations.mac-mini`, `nixosConfigurations.hxtn` | A complete machine configuration that can be built or activated. |
| System profile | `darwin.base`, `nixos.gaming`, `nixos.plasma` | A reusable nix-darwin or NixOS module selected by a host output. It can import Home Manager profiles or contain tightly scoped user settings directly. |
| Home profile | `home.base`, `home.personal`, `home.plasma` | A reusable per-user Home Manager module. Hosts do not select these directly; system profiles import them. |

The build flows in one direction:

```text
feature modules -> profiles -> host output -> machine
                       |
                       +-> selected system profiles import or contain user settings
```

Every `.nix` file under `modules/` is automatically loaded as a peer module
except paths containing `/_`. Feature files contribute settings to profiles,
while files under `modules/hosts/` assemble complete host outputs by selecting
system profiles. The generated `_hardware-configuration.nix` is explicitly
imported by `hxtn`.

Feature modules prefer nixpkgs packages for macOS applications. They use
Homebrew only when nixpkgs does not support the application on macOS.

Profile names are independent labels, not an inheritance hierarchy. For
example, `darwin.personal` does not include `darwin.base`; `mac-mini` explicitly
selects both. The only automatic composition is the Home Manager imports shown
below. `modules/core/options.nix` is the source of truth for every permitted
profile name; adding a profile starts by declaring it there.

As a rule of thumb:

- `base` contains essentials required on every host of that operating system.
- `workstation` contains graphical and interactive workstation features.
- `personal` and `professional` describe the machine's ownership or usage
  context.
- A feature file such as `cursor.nix` contributes configuration to whichever
  of those profiles should receive that feature; the filename names the
  feature, while the profile names define its scope.

### Available system profiles

#### nix-darwin profiles

| Profile | Purpose | Home profiles imported | Selected by |
|---------|---------|------------------------|-------------|
| `darwin.base` | Foundation and system features required on every Mac | `home.base`, `home.darwin` | `mac-mini`, `macbook-pro` |
| `darwin.workstation` | Interactive workstation and development applications | — | `mac-mini`, `macbook-pro` |
| `darwin.personal` | Personal Mac applications, policy, and role-specific settings | `home.personal` | `mac-mini` |
| `darwin.professional` | Professional/work role settings | `home.professional` | `macbook-pro` |

#### NixOS profiles

| Profile | Purpose | Home profiles imported | Selected by |
|---------|---------|------------------------|-------------|
| `nixos.base` | Foundation and system features required on every NixOS host | `home.base` | `hxtn` |
| `nixos.workstation` | Interactive workstation, development, audio, graphics, and input support | `home.nixos` | `hxtn` |
| `nixos.personal` | Personal-machine policy and user configuration | `home.personal` | `hxtn` |
| `nixos.gaming` | Gaming applications, services, and launchers | `home.gaming` | `hxtn` |
| `nixos.plasma` | KDE Plasma desktop session | `home.plasma` | `hxtn` currently |
| `nixos.hyprland` | Staged alternative Hyprland desktop session | `home.hyprland` | Not currently selected |
| `nixos.deskflowServer` | Always-available Deskflow server | — | `hxtn` |
| `nixos.remoteAccess` | Remote SSH access | — | `hxtn` |

### Available Home Manager profiles

| Profile | Purpose | Imported through |
|---------|---------|------------------|
| `home.base` | User identity plus shared Claude Code and Codex packages | `darwin.base`, `nixos.base` |
| `home.darwin` | User configuration shared by every Mac | `darwin.base` |
| `home.personal` | Cross-platform personal configuration such as Alacritty, Git, tmux, and `just` | `darwin.personal`, `nixos.personal` |
| `home.professional` | Work-specific user configuration and Canva Claude instructions | `darwin.professional` |
| `home.nixos` | NixOS workstation user configuration, currently Zed settings | `nixos.workstation` |
| `home.gaming` | Per-user gaming applications | `nixos.gaming` |
| `home.plasma` | Plasma-session user configuration | `nixos.plasma` |
| `home.hyprland` | Hyprland, Waybar, and session user configuration | `nixos.hyprland` |

### Current host composition

| Complete host output | Platform | System profiles selected | Home profiles reached |
|----------------------|----------|--------------------------|-----------------------|
| `darwinConfigurations.mac-mini` | `aarch64-darwin` | `darwin.base`, `darwin.workstation`, `darwin.personal` | `home.base`, `home.darwin`, `home.personal` |
| `darwinConfigurations.macbook-pro` | `aarch64-darwin` | `darwin.base`, `darwin.workstation`, `darwin.professional` | `home.base`, `home.darwin`, `home.professional` |
| `nixosConfigurations.hxtn` | `x86_64-linux` | `nixos.base`, `nixos.workstation`, `nixos.plasma`, `nixos.personal`, `nixos.gaming`, `nixos.deskflowServer`, `nixos.remoteAccess` | `home.base`, `home.nixos`, `home.plasma`, `home.personal`, `home.gaming` |

The staged Hyprland change replaces `nixos.plasma` with `nixos.hyprland`; that
also replaces `home.plasma` with `home.hyprland`.

For an expanded explanation of loading and profile composition, see
[`docs/module-loading.md`](docs/module-loading.md) or the interactive
[`docs/architecture.html`](docs/architecture.html).

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
- Role/purpose: `personal`, `professional`, `server`

If the future devbox is macOS or NixOS, it fits this host model directly. If it
is a non-NixOS Linux machine, the repo will probably need a separate
standalone-Home-Manager target rather than another `nixosConfigurations` or
`darwinConfigurations` entry.

## Notes

### Comment policy

Comments are safety rails for changing code, not feature documentation. Keep a
comment beside the implementation only when it explains a non-obvious
constraint, compatibility requirement, or security decision that must remain
synchronized with that code.

Feature descriptions, configuration ownership, operational instructions, and
temporary-workaround details belong in this README or in focused documentation
linked from it. Do not add comments that restate names, narrate the following
option, or preserve disabled code. A temporary implementation may carry a short
pointer to its documented removal criteria.

Content emitted by Nix follows the conventions of its target format rather
than Nix's comment policy. Generated files, including the NixOS hardware
configuration, retain their upstream warnings and comments.

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
- Store-backed raw files: `zsh` and the Canva-specific `CLAUDE.md`
- Out-of-store files: `~/.config/alacritty/alacritty.toml` and Karabiner's JSON
  configuration

Claude Code and Codex follow the same ownership rule: this repo installs each
CLI through `home.base`, declares shared system configuration, and leaves the
tool's per-device user configuration writable.

| Tool | System-managed configuration | Tool-owned user configuration |
|------|------------------------------|-------------------------------|
| Claude Code | The shared attribution opt-out is installed on every host through Claude Code's managed-settings layer. | `~/.claude/settings.json` contains personal UI state and is intentionally not tracked by this repo. |
| Codex | Shared MCP definitions are declared in `/etc/codex/config.toml` on every host. | `~/.codex/config.toml` contains per-device settings and UI state. |

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

Karabiner's tracked JSON maps Caps Lock to Left Control on every keyboard and
swaps Right Option with Right Command on the MX Keys Mini connected through
the Logi Bolt receiver (vendor `1133`, product `50504`). Its UI writes through
the out-of-store symlink, so changing remaps there overwrites the tracked JSON
directly.

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

### Prepared Hyprland and Deskflow InputCapture

`hxtn` still selects `config.nixos.plasma`; the alternative
`config.nixos.hyprland` capability is staged for a deliberate first boot.
Deskflow requires the
[InputCapture](https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.InputCapture.html)
portal to move its pointer and keyboard between Wayland desktops. The required
upstream work merged in July 2026:

- [xdg-desktop-portal-hyprland#268](https://github.com/hyprwm/xdg-desktop-portal-hyprland/pull/268), merged as `0e832b50ecc49d4bae01a29845c1b3fafc5c5c99`
- [Hyprland#7919](https://github.com/hyprwm/Hyprland/pull/7919), merged as `0b0d7ede2192ae515638890037890bdecca6eba2`

#### Large temporary upstream caveat

This support is newer than the Hyprland/XDPH pair in NixOS 25.11. Even the
pinned Hyprland revision currently locks an older XDPH, so `flake.nix` pins a
known post-merge Hyprland revision and overrides its nested `xdph` input with
the merged XDPH revision. `modules/hyprland.nix` also aligns Mesa with
Hyprland's nixpkgs input, as recommended by Hyprland when mixing its flake with
a stable NixOS release.

These are packaging bridges, not permanent configuration. Revisit them once
Hyprland's own lock contains the merged XDPH work. Remove the nested `xdph`
override first; once stable nixpkgs ships a matching Hyprland/XDPH pair, remove
the `hyprland` flake input, its Cachix/Mesa plumbing, and the explicit
`package`/`portalPackage` overrides in favour of the NixOS packages.

#### First rollout

In `modules/hosts/hxtn/hxtn.nix`, make the desktop capability swap:

```nix
config.nixos.plasma
```

becomes:

```nix
config.nixos.hyprland
```

Do not use `just switch` for the first desktop replacement: that would stop the
running display manager. Build it as the next boot generation instead. The
current Nix daemon does not know about the Hyprland cache until the new
generation is active, so supply the cache once on the command line:

```sh
sudo nixos-rebuild boot --flake .#hxtn \
  --option extra-substituters https://hyprland.cachix.org \
  --option extra-trusted-public-keys \
  'hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc='
```

Reboot only when ready. The previous Plasma generation remains selectable in
the systemd-boot menu if Hyprland or Deskflow fails. No configuration command
in this section should be run remotely without someone able to use that menu.

After logging in, confirm that the portal is healthy and then test Deskflow:

```sh
systemctl --user status xdg-desktop-portal-hyprland
systemctl --user status xdg-desktop-portal
```

Deskflow starts as its native GUI so its existing settings and tray controls
remain available. Configure it as the server if its user settings do not
already do so. `Super+Shift+Escape` is the emergency Hyprland binding that
forcibly releases an active InputCapture session.

Dolphin is intentionally retained for the first migration. This keeps some Qt
and KDE Frameworks libraries, but does not retain Plasma, KWin, or SDDM. Revisit
the file-manager choice after the Hyprland setup has settled.
