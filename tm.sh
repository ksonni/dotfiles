#!/bin/bash

COLORS=(
  "#1E1F22"   # Grey - graphite dark (default)
  "#222B26"   # Green - moss slate
  "#1F2430"   # Blue - night ocean
  "#2B1F1F"   # Red - dried blood
  "#2A211B"   # Orange - burnt umber
  "#2A271E"   # Yellow - muted mustard charcoal
  "#2A1F2E"   # Pink - muted plum
)

# Args parsing
RANDOM_BG=1
SESSION_ARG=""
STATUS=0
for arg in "$@"; do
  case "$arg" in
    --random-bg) RANDOM_BG=1 ;;    # Selects a random color when starting a session
    --no-random-bg) RANDOM_BG=0 ;; # Uses the default color 0
    --status) STATUS=1 ;;
    *) SESSION_ARG="$arg" ;;
  esac
done

# Sets EDITOR_BG to a random color based on the day of year
choose_bg() {
  if (( RANDOM_BG )); then
    dow=$(date +%u)
    day_of_year=$(date +%j)
    
    # Make sure weekends don't skew the randomness
    if (( dow == 6 )); then
        day_of_year=$((10#$day_of_year - 1))
    elif (( dow == 7 )); then
        day_of_year=$((10#$day_of_year - 2))
    fi
    (( day_of_year < 0 )) && day_of_year=0

    idx=$((10#$day_of_year % ${#COLORS[@]}))
    export EDITOR_BG="${COLORS[$idx]}"
  else
    export EDITOR_BG="${COLORS[0]}"
  fi
}
choose_bg

if (( STATUS )); then
    echo "bg=$EDITOR_BG"
    exit 0
fi

# Copy these to .tmux.conf as well for normal sessions
apply_bg() {
    tmux set-option -g window-style "bg=$EDITOR_BG"
    tmux set-option -g window-active-style "bg=$EDITOR_BG"
    tmux set-option -g status-style "bg=$EDITOR_BG"
    tmux set-option -g pane-border-style "bg=$EDITOR_BG,fg=#323438"
    tmux set-option -g pane-active-border-style "bg=$EDITOR_BG,fg=#323438"
}

# Starts a session named after the current directory
# If the name of a session is provided, it attaches to it

SESSION_NAME=${SESSION_ARG:-$(basename "$PWD")}

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach-session -t "$SESSION_NAME"
else
    tmux new-session -d -s "$SESSION_NAME" -n editor
    apply_bg
    tmux send-keys -t "$SESSION_NAME:editor" 'nvim .' C-m
    tmux new-window -t "$SESSION_NAME"
    tmux select-window -t "$SESSION_NAME:0"
    tmux attach-session -t "$SESSION_NAME"
fi

