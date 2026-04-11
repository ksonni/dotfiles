# Dotfiles

Neovim config (netrw, no nvim-tree) plus configs for tmux, Wezterm, and IntelliJ. Requires Neovim 0.11+.

## Setup

Clone to `~/.config/nvim`. Run `install.sh` for dependencies (Mac/Linux).

Symlink the others:
- `~/.tmux.conf` → `.tmux.conf`
- `~/.wezterm.lua` → `.wezterm.lua`
- IntelliJ keymaps dir → `keymaps.xml`, then select "CustomKeymaps" in settings
  - Mac location: `~/Library/Application Support/JetBrains/IntelliJIdea<VERSION>/keymaps/`
  - These keymaps try to be as close to the neovim ones if using IntelliJ

## Neovim

LSP via Mason (Go, TypeScript, Python, Lua, Protobuf), Telescope for navigation, Harpoon for file marks, Fugitive for git. Keymaps in `lua/default/remap.lua`.

Plugins managed by lazy.nvim. Refresh packages with `:Lazy sync` (or `:Lazy` → `S`).

Code review workflow: `:Review [branch]` diffs against master/main merge-base with commands to jump from diff hunks directly to the file at the relevant line.

Go test runner detects the enclosing test function and uses `go test -run` or Bazel if a `BUILD.bazel` is present. Override with `$VIMTESTCMD`.

## AI Agent Integration

`assist.sh` launches an AI agent in a tmux pane (tries `claude` → `copilot` → `codex`). Neovim can send prompts with file/line references directly to that pane via `:Bot`. Set `$VIMAGENT` to prefer a specific agent.

Tmux bindings in the editor window open the assist pane with or without `--yolo`.

## Tmux

`tm.sh` creates or attaches to a session named after the current directory, with an `editor` window (`nvim .`) and a terminal. Alias as `tm` in `.zshrc`.

