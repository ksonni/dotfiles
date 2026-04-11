#!/bin/bash

install_node() {
  if command -v volta &>/dev/null; then
    volta install node
  elif command -v nvm &>/dev/null; then
    nvm install --lts
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install node
  else
    sudo apt-get install -y nodejs
  fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install ripgrep tmux neovim
  xcode-select --install
else
  sudo apt-get update
  sudo apt-get install -y ripgrep tmux xclip neovim
fi

install_node

# Only needed if developing
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install pipx
else
  sudo apt-get install -y pipx
fi
pipx ensurepath
pipx install pre-commit
pre-commit install
