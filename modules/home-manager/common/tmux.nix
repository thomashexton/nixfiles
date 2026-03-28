{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;

    shell = if pkgs.stdenv.hostPlatform.isDarwin then "/bin/zsh" else "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    focusEvents = true;
    historyLimit = 50000;
    escapeTime = 0;
    customPaneNavigationAndResize = true;

    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g renumber-windows on

      unbind %
      unbind '"'
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind -r C-h previous-window
      bind -r C-l next-window

      set -g status-interval 10
      set -g status-justify absolute-centre
      set -g status-position top
      set -g status-right "%H:%M"
      set -g status-style 'bg=default'

      set -g window-status-current-format '#[fg=black,bg=green] #I #W '
      set -g window-status-format '#[fg=white,bg=brightblack] #I #W '

      set -g pane-active-border-style 'fg=green,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'

      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"
      bind x kill-pane
    '';

    sensibleOnTop = true;

    plugins = with pkgs.tmuxPlugins; [
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
      yank
    ];
  };

  xdg.configFile."tmux/tmux.conf".force = true;
}
