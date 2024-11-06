#!/bin/bash

function install_vim_plug() {
  local plug_path="$HOME/.vim/autoload/plug.vim"
  local plug_url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

  if [ ! -f "$plug_path" ]; then
    echo "Downloading vim-plug..."
    if curl -fLo "$plug_path" --create-dirs "$plug_url"; then
      echo "vim-plug installed successfully."
    else
      echo "Failed to download vim-plug."
      return 1
    fi
  else
    echo "vim-plug already exists."
  fi
}

function install_vim_plugins() {
  echo "Installing vim plugins..."
  vim -c "PlugInstall" -c "qa"
}

function setup_vim() {
  install_vim_plug
  install_vim_plugins
}
