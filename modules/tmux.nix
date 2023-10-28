{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.tmux;
in {
  options.services.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.tmux ];

    programs.tmux = {
      enable = true;
      shortcut = "a";
      escapeTime = 0;
      extraConfig = ''
        set -g default-terminal "xterm-256color"
        # required to fix terminal colors
        set-option -ga terminal-overrides ",xterm-256color:Tc"

        bind c new-window -c "#{pane_current_path}"

        # split current window vertically/horizontally
        bind - split-window -v -c "#{pane_current_path}"
        bind _ split-window -h -c "#{pane_current_path}"

        # pane resizing
        bind -r H resize-pane -L 2
        bind -r J resize-pane -D 2
        bind -r K resize-pane -U 2
        bind -r L resize-pane -R 2

        # pane navigation
        bind -r h select-pane -L
        bind -r j select-pane -D
        bind -r k select-pane -U
        bind -r l select-pane -R

        # pane swapping
        bind < swap-pane -D
        bind > swap-pane -U

        # window navigation
        unbind n
        unbind p
        bind -r C-h previous-window
        bind -r C-l next-window

        unbind '"'
        unbind %

        set-option -g status-position top

        # set-option -g status-style fg=colour136,bg=colour235 #yellow and base02
        set-option -g status-style fg=colour136,bg=#1E1E2D #yellow and base02

        # default window title colors
        set-window-option -g window-status-style fg=colour244,bg=default #base0 and default

        # active window title colors
        set-window-option -g window-status-current-style fg=colour166,bg=default #orange and default
        #set-window-option -g window-status-current-style bright

        # pane border
        set-option -g pane-border-style fg=colour235 #base02
        set-option -g pane-active-border-style fg=colour240 #base01

        set -g status-justify "centre"

        # pane number display
        set-option -g display-panes-active-colour colour33 #blue
        set-option -g display-panes-colour colour166 #orange

        set-option -g status-left ""
        set-option -g status-right ""
      '';
    };
  };
}
