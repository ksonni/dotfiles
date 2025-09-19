# Dotfiles

This is mainly a minimalistic Neovim config with netrw. 
Also contains files for other editors/utils which Neovim will ignore.

## Neovim
- This setup has been designed to work with Neovim 0.11
- Clone the repo to `~/.config/nvim` for Neovim to pick it up.

## Tmux
- Symlink `.tmux.conf` to `~/.tmux.conf` to confiure tmux.
- `tm.sh` is a small script to create a tmux session or attach to an existing one based on 
the name of the current directory with a pre-made Neovim + 1 terminal setup.
- Convenient to make an alias for this called `tm` in the `~/.zshrc` file on MacOS.

## IntelliJ
- Symlink `keymaps.xml` to IntelliJ's keymaps directory and choose "CustomKeymaps" from the settings window.
- On Mac OS it's here - `~/Library/Application\ Support/JetBrains/IntelliJIdea2024.2/keymaps/`

