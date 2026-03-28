{ config, lib, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  home.activation.macMiniDotfilesCleanup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export HOME=${lib.escapeShellArg homeDir}

    for root in "$HOME/.config" "$HOME/.local/bin" "$HOME/.claude"; do
      if [ -d "$root" ]; then
        find "$root" -type l -print | while IFS= read -r path; do
          target="$(readlink "$path" || true)"

          case "$target" in
            *"/dotfiles/"*|../dotfiles/*|../../dotfiles/*|../../../dotfiles/*|../../../../dotfiles/*)
              rm -f "$path"
              ;;
          esac
        done
      fi
    done

    if [ -d "$HOME/.config/dotfiles-bootstrap" ]; then
      rm -f "$HOME/.config/dotfiles-bootstrap/profile"
      rmdir "$HOME/.config/dotfiles-bootstrap" 2>/dev/null || true
    fi

    tpm_dir="$HOME/.tmux/plugins/tpm"

    if [ -d "$tpm_dir" ]; then
      remote_url="$(${pkgs.git}/bin/git -C "$tpm_dir" config --get remote.origin.url 2>/dev/null || true)"

      case "$remote_url" in
        https://github.com/tmux-plugins/tpm|https://github.com/tmux-plugins/tpm.git|git@github.com:tmux-plugins/tpm|git@github.com:tmux-plugins/tpm.git)
          rm -rf "$tpm_dir"
          ;;
      esac
    fi

    if [ -d "$HOME/.tmux/plugins" ] && [ -z "$(ls -A "$HOME/.tmux/plugins")" ]; then
      rmdir "$HOME/.tmux/plugins"
    fi

    if [ -d "$HOME/.tmux" ] && [ -z "$(ls -A "$HOME/.tmux")" ]; then
      rmdir "$HOME/.tmux"
    fi
  '';
}
