#!/bin/bash

[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

export HOMEBREW_NO_ENV_HINTS=1

# Function to update, upgrade, and clean up Homebrew
brew_update() {
  brew update-reset

  echo "Updating Homebrew..."
  brew update

  echo "Upgrading all installed packages..."
  brew upgrade
  brew upgrade --cask

  echo "Cleaning up old versions of installed packages..."
  brew cleanup --prune=all --verbose --scrub
  rm -rf "$(brew --cache)"
  brew autoremove

  brew doctor

  echo "Homebrew maintenance completed."
}

brew_setup_base() {
  PACKAGES=('tmux' 'tree' 'vim' 'git' 'curl' 'wget' 'fzf' 'v2ray' 'zoxide' 'gh')
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
