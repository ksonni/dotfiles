#!/bin/bash

# Starts a session named after the current directory
# If the name of a session is provided, it attaches to it

SESSION_NAME=${SESSION_ARG:-$(basename "$PWD")}

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach-session -t "$SESSION_NAME"
else
    tmux new-session -d -s "$SESSION_NAME" -n editor
    tmux send-keys -t "$SESSION_NAME:editor" 'nvim .' C-m
    tmux new-window -t "$SESSION_NAME"
    tmux select-window -t "$SESSION_NAME:1"
    tmux attach-session -t "$SESSION_NAME"
fi

