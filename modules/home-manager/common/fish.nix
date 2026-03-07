{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # Abbreviations expand in-place (you see what you're running).
    # Derived from actual shell history — only what's used.
    # Note: giu/giU/gfm are work-specific, kept in iCloud secrets.
    shellAbbrs = {
      gcm  = "git commit --message";
      gco  = "git checkout";
      gp   = "git push";
      gbc  = "git checkout -b";
      gr   = "git rebase";
      gri  = "git rebase --interactive";
      grc  = "git rebase --continue";
      gws  = "git status --short";
      gb   = "git branch";
      gbx  = "git branch --delete";
      gpF  = "git push --force-with-lease";
      gl   = "git pull";
    };

    shellAliases = {
      vim = "nvim";
      vi  = "nvim";
      wx  = "curl v2.wttr.in";
    };

    # Functions for anything needing variable expansion or complex paths
    functions = {
      e = {
        description = "Open in editor";
        body = "eval $EDITOR $argv";
      };
      hosts = {
        description = "Edit /etc/hosts";
        body = "eval sudo $EDITOR /etc/hosts";
      };
      ic = {
        description = "Navigate to iCloud directory";
        body = ''cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'';
      };
      pubip = {
        description = "Print public IP and copy to clipboard";
        body = ''
          set ip (curl -s ipv4.icanhazip.com)
          echo $ip
          echo $ip | pbcopy
        '';
      };
    };

    shellInit = ''
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/.cargo/bin
      set -gx EDITOR 'zed --wait'
    '';

    interactiveShellInit = ''
      if not set -q TMUX
        exec tmux new-session -A -s main
      end
    '';

  };

  home.packages = with pkgs; [
    fishPlugins.autopair
    fishPlugins.done
    just
  ];

  # Replaces fishPlugins.z — more modern, better scoring
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
