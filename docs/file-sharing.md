# File sharing between `mac-mini` and `hxtn`

Both machines expose authenticated SMB file sharing and advertise it over
Bonjour/mDNS.

## Addresses and credentials

| Direction | Address | Username | Password |
| --- | --- | --- | --- |
| Mac to `hxtn` | `smb://hxtn.local/thomashexton` | `thomashexton` | The Samba password set with `sudo smbpasswd -a thomashexton` on `hxtn` |
| `hxtn` to Mac | `smb://mac-mini.local/` | `thomashexton` | The Mac login password |

Finder can remember the `hxtn` Samba password in the macOS Keychain. Dolphin
can save the Mac credential in KDE Wallet.

The `.local` suffix matters: `mac-mini.local` and `hxtn.local` are Bonjour
names, whereas bare hostnames depend on other LAN name-resolution mechanisms.
The NixOS Avahi configuration enables both advertising and `.local`
resolution.

## How the macOS controls fit together

The macOS File Sharing window combines several related but independent layers:

| Setting | Meaning |
| --- | --- |
| **File Sharing** | Master switch for the entire file server |
| **Full Disk Access** | Expands what the file-sharing service may read once it is running |
| **Shared Folders** | Explicit shares and their permissions |
| **Options → SMB** | Enables SMB and chooses which accounts may authenticate |

For this configuration:

- `thomashexton` is an administrator.
- macOS allows administrators to access mounted volumes over SMB.
- Logging in from `hxtn` as `thomashexton` therefore provides substantially
  broader access than the Public Folder alone.
- With **Full Disk Access** off, macOS privacy protections can block folders
  such as Desktop, Documents and Downloads.
- With **Full Disk Access** on, the authenticated administrator can also reach
  those protected folders.

In short, `thomashexton` can browse the Mac's volumes and home directory
regardless of which folders are explicitly listed under **Shared Folders**,
subject to the **Full Disk Access** setting.

The Public Folder entry matters primarily for:

- guest access;
- non-administrator accounts; and
- limiting a dedicated sharing account to explicitly selected folders.

For browsing the Mac's files from `hxtn`, the intended macOS state is:

1. **File Sharing:** On
2. **Full Disk Access:** On
3. **Options → Share files and folders using SMB:** On
4. **Windows File Sharing → `thomashexton`:** On
5. Authenticate from `hxtn` as `thomashexton`.

This is convenient but broad. Anyone who obtains the Mac password and can
reach its SMB service could access much of the Mac. A dedicated **Sharing
Only** account plus explicit shared folders is the tighter alternative.

## `hxtn` implementation

`modules/remote-access.nix`:

- exports `/home/thomashexton` as an authenticated, writable share;
- requires SMB 3 and encrypted sessions;
- disables guest access and legacy NetBIOS discovery;
- advertises `_smb._tcp` through Avahi for Finder discovery;
- enables mDNS name resolution so `mac-mini.local` works from NixOS; and
- opens TCP port 445 for SMB.

After changing the configuration, activate it on `hxtn`:

```console
sudo nixos-rebuild switch --flake ~/nixfiles#hxtn
```

Create or reset the separate Samba credential with:

```console
sudo smbpasswd -a thomashexton
```

## Troubleshooting

Test the Bonjour name from `hxtn`:

```console
getent hosts mac-mini.local
```

If name resolution is unavailable before a rebuild, connect directly to the
Mac's LAN IP using an address such as `smb://192.168.10.124/`. The IP can
change unless it has a DHCP reservation.

On the Mac, `dns-sd -B _smb._tcp` lists advertised SMB servers. On `hxtn`,
`zeroconf:/` in Dolphin displays Bonjour services when KDE's Zeroconf
integration is installed; the direct `smb://...` address remains the most
reliable entry point.
