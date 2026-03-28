{ ... }:

{
  xdg.configFile."zim/.zimrc" = {
    force = true;
    text = ''
      # Core functionality
      zmodule environment
      zmodule input
      zmodule utility
      zmodule git

      # Prompt dependencies and prompt
      zmodule duration-info
      zmodule git-info
      zmodule asciiship

      # Completion
      #zmodule zsh-users/zsh-completions --fpath src
      #zmodule completion

      # Additional tools
      zmodule https://github.com/agkozak/zsh-z

      # Modules that must be initialized last
      zmodule zsh-users/zsh-syntax-highlighting
      zmodule zsh-users/zsh-history-substring-search
      zmodule zsh-users/zsh-autosuggestions
    '';
  };

  xdg.configFile."zsh/.zshrc" = {
    force = true;
    text = ''
      if [[ -d "''${XDG_CONFIG_HOME}/zsh/custom" ]]; then
        for config_file in "''${XDG_CONFIG_HOME}/zsh/custom"/*.zsh; do
          if [[ -f "$config_file" ]]; then
            source "$config_file"
          fi
        done
      fi
    '';
  };

  xdg.configFile."zsh/custom/aliases.zsh" = {
    force = true;
    text = ''
      alias ic="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"

      alias e="''${EDITOR}"
      alias ve="''${VISUAL_EDITOR}"

      alias vim="nvim"
      alias vi="nvim"

      alias hosts="sudo ''${VISUAL_EDITOR} /etc/hosts"

      alias wx="curl v2.wttr.in"

      alias pubip="curl -s ipv4.icanhazip.com | tee >(pbcopy)"
    '';
  };

  xdg.configFile."zsh/custom/environment.zsh" = {
    force = true;
    text = ''
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.cargo/bin:$PATH"

      export ZSHZ_DATA="''${XDG_CACHE_HOME}/.z"

      export EDITOR='zed --wait'
      export VISUAL_EDITOR='zed --wait'

      if [ -z "$TMUX" ]; then
        tmux new-session -A -s main
      fi
    '';
  };

  xdg.configFile."zsh/custom/functions.zsh" = {
    force = true;
    text = ''
      function reset_tracked_branches {
          git remote set-branches origin master green 'thomashexton-*' 'jayt-*' 'regina*' &&
          git fetch --prune &&
          git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs --no-run-if-empty git branch -D
      }
    '';
  };

  xdg.configFile."zsh/custom/zim.zsh" = {
    force = true;
    text = ''
      # Start configuration added by Zim install {{{
      #
      # User configuration sourced by interactive shells
      #

      setopt HIST_IGNORE_ALL_DUPS

      bindkey -e

      WORDCHARS=''${WORDCHARS//[\/]}

      zstyle ':zim:git' aliases-prefix 'g'

      ZSH_AUTOSUGGEST_MANUAL_REBIND=1
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

      export ZIM_CONFIG_FILE="''${XDG_CONFIG_HOME}/zim/.zimrc"
      export ZIM_HOME="''${XDG_CACHE_HOME}/zim"

      if [[ ! -e ''${ZIM_HOME}/zimfw.zsh ]]; then
        curl -fsSL --create-dirs -o ''${ZIM_HOME}/zimfw.zsh \
            https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
      fi

      if [[ ! ''${ZIM_HOME}/init.zsh -nt ''${ZIM_CONFIG_FILE} ]]; then
        source ''${ZIM_HOME}/zimfw.zsh init -q
      fi

      source ''${ZIM_HOME}/init.zsh

      zmodload -F zsh/terminfo +p:terminfo
      for key ('^[[A' '^P' ''${terminfo[kcuu1]}) bindkey ''${key} history-substring-search-up
      for key ('^[[B' '^N' ''${terminfo[kcud1]}) bindkey ''${key} history-substring-search-down
      for key ('k') bindkey -M vicmd ''${key} history-substring-search-up
      for key ('j') bindkey -M vicmd ''${key} history-substring-search-down
      unset key

      unalias gt gtl gts gtv gtx 2>/dev/null
      unalias gh ghw 2>/dev/null

      # }}} End configuration added by Zim install
    '';
  };
}
