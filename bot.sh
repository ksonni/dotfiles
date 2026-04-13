#!/usr/bin/env sh

set -eu

# Launches an AI agent in the bot pane, falling back to a standard shell if none is installed.
# Pass --yolo to enable all-permissions mode for agents.

tmux set-option -pt "$TMUX_PANE" @role bot

yolo=0
for arg in "$@"; do
  case "$arg" in
    --yolo) yolo=1 ;;
  esac
done

find_cmd() {
  cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    command -v "$cmd"
    return 0
  fi
  return 1
}

try_cmd() {
  cmd="$1"
  shift
  if find_cmd "$cmd" >/dev/null 2>&1; then
    exec "$cmd" "$@"
  fi
}

try_bot() {
  if [ "$yolo" = "1" ]; then
    case "$1" in
      claude)  try_cmd claude --dangerously-skip-permissions ;;
      copilot) try_cmd copilot --yolo ;;
      codex)   try_cmd codex --yolo ;;
    esac
  else
    try_cmd "$1"
  fi
}

if [ -n "${VIMAGENT:-}" ]; then
  try_bot "$VIMAGENT"
else
  try_bot claude
  try_bot copilot
  try_bot codex
fi

exec "${SHELL:-/bin/sh}"

