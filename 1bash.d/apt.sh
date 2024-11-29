#!/bin/bash

# Function to update, upgrade, and clean up apt
apt_update() {
  echo "Updating package lists..."
  sudo apt update

  echo "Upgrading all installed packages..."
  sudo apt upgrade -y

  echo "Cleaning up old versions of installed packages..."
  sudo apt autoremove -y
  sudo apt clean

  echo "APT maintenance completed."
}

apt_setup_base() {
  PACKAGES=('tmux' 'tree' 'vim' 'git' 'curl' 'wget')
  echo "Installing packages with apt"
  sudo apt update
  sudo apt upgrade -y
  # check if package already installed, if not, install it
  for i in "${PACKAGES[@]}"; do
    if dpkg -l | grep -q "^ii  $i "; then
      echo "$i already installed"
    else
      echo "Installing $i"
      sudo apt install -y $i
    fi
  done
  sudo apt autoremove -y
  sudo apt clean
}

# Uncomment the following lines to run the functions
# apt_update
# apt_setup_base
