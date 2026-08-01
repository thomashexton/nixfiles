# nixfiles

NixOS and nix-darwin host configurations managed with flakes and Home Manager.

## Hosts

| Host | Platform | Selected profiles |
| --- | --- | --- |
| `hxtn` | `x86_64-linux` | `nixos.base`, `nixos.workstation`, `nixos.personal`, `nixos.gaming`, `nixos.plasma`, `nixos.deskflowServer`, `nixos.remoteAccess` |
| `mac-mini` | `aarch64-darwin` | `darwin.base`, `darwin.workstation`, `darwin.personal` |
| `macbook-pro` | `aarch64-darwin` | `darwin.base`, `darwin.workstation` |

`hxtn` currently uses Plasma. A Hyprland profile is available but is not
selected by any host.

## Architecture

- `flake.nix` declares inputs and passes `modules/` to flake-parts through
  import-tree.
- Every `.nix` file under `modules/` is loaded as a peer flake-parts module,
  except paths containing `/_`.
- Feature modules contribute NixOS, nix-darwin, or Home Manager configuration
  to the profiles declared in `modules/core/options.nix`.
- Files under `modules/hosts/` construct host outputs by selecting system
  profiles. Those system profiles import the required Home Manager profiles.
- `_hardware-configuration.nix` is the deliberate exception to automatic
  loading and is imported directly by the `hxtn` host module.

Put reusable behavior in a feature module and assign it to the narrowest
existing profile that needs it. Keep host identity, state versions, boot
configuration, and hardware-specific values in the host module. Add a profile
only when it represents a capability that hosts need to select independently.

See [Module loading and composition](docs/module-loading.md) for the distinction
between automatic file discovery and profile selection.

Home Manager is embedded in both the NixOS and nix-darwin builds. Apply this
repository through the system configuration; do not run `home-manager switch`.

## Use

```console
just fmt                 # format Nix files
just fmt-check           # check formatting without changing files
just check               # run flake checks
just validate hxtn       # build a NixOS host without activating it
just validate mac-mini   # build a nix-darwin host without activating it
just switch              # activate the configuration for the current host
```

On a new Mac, install Nix before cloning this repository. The first activation
must bootstrap nix-darwin because `darwin-rebuild` is not yet installed:

```console
nix run nixpkgs#just -- bootstrap mac-mini
```

Use `macbook-pro` instead when bootstrapping that host. Later activations use
`just switch`.

## Operational constraints

Tracked application configuration that must remain writable is linked to
mutable files in this repository with `mkOutOfStoreSymlink`; editing either
side changes the tracked file. Declarative files that applications do not
rewrite remain backed by the Nix store.

Deskflow's application settings and generated server layout are intentionally
mutable tracked files under `modules/deskflow/`. TLS keys, certificates, and
trusted fingerprints remain untracked runtime state. On Wayland, Deskflow still
requires `wl-clipboard`; remove that package and its `wlClipboard` setting once
Deskflow uses portal clipboard support.

The unselected Hyprland profile pins a matching Hyprland/XDPH pair to provide
the InputCapture support required by Deskflow. The pin can be removed when the
selected nixpkgs release provides a compatible pair.
