#!/bin/bash

# Function to update, upgrade, and clean up Homebrew
brew_update() {
  echo "Updating Homebrew..."
  brew update

  echo "Upgrading all installed packages..."
  brew upgrade

  echo "Cleaning up old versions of installed packages..."
  brew cleanup --prune=all
  brew autoremove

  echo "Homebrew maintenance completed."
}

brew_setup_base() {
  PACKAGES=('tmux' 'tree' 'vim' 'zsh' 'git' 'curl' 'wget' 'fzf')
  echo "Install packages with brew"
  brew update
  brew upgrade
  # check if package already installed, if not, install it
  for i in "${PACKAGES[@]}"; do
    if brew ls --versions $i >/dev/null; then
      echo "$i already installed"
    else
      echo "Installing $i"
      brew install $i
    fi
  done
  brew cleanup --prune=all
  brew autoremove
}
