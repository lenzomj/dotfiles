# Enable zsh 
#set -g default-command /bin/zsh 
#set -g default-shell /bin/zsh

# Enable bash
#set -g default-command /bin/bash
#set -g default-shell /bin/bash

# Set mouse selection options for iTerm
#set -g mouse-select-pane on
#set-option -g mouse-resize-pane on
#set-option -g mouse-select-window on
#set-window-option -g mode-mouse on

# Change pane selection commands
unbind %
bind | split-window -h
bind - split-window -v

# look good
set -g default-terminal "xterm-256color"

# Set status-bar options
#setw -g automatic-rename
#set -g status-bg black
#set -g status-fg white
#set -g status-left '#[fg=yellow]#H'
#set-window-option -g window-status-current-bg yellow
#set-window-option -g window-status-current-fg black
#set -g status-right '#[fg=yellow]#(uptime | cut -d "," -f 2-)'
#set -g status-right '#[fg=yellow]#(uptime | cut -d "," -f 1)'
#set-window-option -g clock-mode-colour yellow

# Set window notifications
#setw -g monitor-activity on
#set -g visual-activity on

# Set colors
#set-option -g pane-border-fg colour240
#set-option -g pane-active-border-fg yellow
#set -g default-terminal $ZSH_TMUX_TERM
#source $HOME/.tmux.conf
#
#
