# Dotfiles

Neovim config (netrw, no nvim-tree) plus configs for tmux, Wezterm, and IntelliJ. Requires Neovim 0.12+.

## Setup

Clone to `~/.config/nvim` and run `install.sh` for dependencies (Mac/Linux).

Symlink the others:
- `~/.tmux.conf` → `.tmux.conf`
- `~/.wezterm.lua` → `.wezterm.lua`
- IntelliJ keymaps dir → `keymaps.xml`, then select "CustomKeymaps" in settings
  - Mac location: `~/Library/Application Support/JetBrains/IntelliJIdea<VERSION>/keymaps/`
  - These keymaps try to be as close to the neovim ones if using IntelliJ

## Neovim

LSP via Mason (Go, TypeScript, Python, Lua, Protobuf), Telescope for navigation, Harpoon for file marks, Fugitive for git. Keymaps in `lua/default/remap.lua`.

Plugins are managed by lazy.nvim. Use `:Lazy sync` inside Neovim to install missing plugins, remove unused plugins, and update checkouts to match `lazy-lock.json`. Use `:Lazy update` when intentionally updating plugin pins and commit the changed `lazy-lock.json`.

If any issues are seen after the packer to lazy.nvim migration, wipe the Neovim data dir with `rm -rf ~/.local/share/nvim` and restart.

Code review workflow: `:Review [branch]` diffs against master/main merge-base with commands to jump from diff hunks directly to the file at the relevant line.

Go test runner detects the enclosing test function and uses `go test -run` or Bazel if a `BUILD.bazel` is present. Override with `$VIMTESTCMD`.

## AI Agent Integration

`bot.sh` launches an AI agent in a tmux pane (tries `claude` → `copilot` → `codex`). Neovim can send prompts with file/line references directly to that pane via `:Bot`. Set `$VIMAGENT` to prefer a specific agent.

Tmux bindings in the editor window open the bot pane with or without `--yolo`. The `bot` alias (from `.zshrc`) launches it directly from the terminal. Managing multiple bot panes through `:Bot` is currently not supported.

## Tmux

`tm.sh` creates or attaches to a session named after the current directory, with an `editor` window (`nvim .`) and a terminal. Alias as `tm` in `.zshrc`.

## Roadmap
- [x] Upgrade plugins
    - [x] telescope
    - [x] dracula
    - [x] harpoon
    - [x] fugitive
    - [x] lspconfig & co
    - [x] nvim-cmp & co
    - [x] autopairs
    - [x] ufo
    - [x] lualine
    - [x] lsp-progress
- [x] Migrate to neovim 0.12
- [x] Upgrade treesitter-nvim
- [x] Replace packer with lazy
- [ ] Investigate lsp-zero
- [ ] Update bot for multi agent workflows
