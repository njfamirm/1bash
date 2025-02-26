setup_mac() {
  printf "⚙️ Configure Desktop...\n"
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
  defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool true

  printf "⚙️ Configure Finder...\n"
  defaults write com.apple.finder "QuitMenuItem" -bool true                    # Allow quitting via ⌘ + Q; doing so will also hide desktop icons
  defaults write NSGlobalDomain "AppleShowAllExtensions" -bool true            # Show all filename extensions
  defaults write com.apple.finder "AppleShowAllFiles" -bool true               # Show hidden files by default
  defaults write com.apple.finder "ShowPathbar" -bool true                     # Show path bar
  defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"        # Use list view in all Finder windows by default
  defaults write com.apple.finder "_FXSortFoldersFirst" -bool true             # Keep folders on top when sorting by name
  defaults write com.apple.finder "FinderSpawnTab" -bool true                  # Open folders in tabs instead of new windows
  defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"        # Search the current folder
  defaults write com.apple.finder "FXRemoveOldTrashItems" -bool true           # Empty Trash after 30 days
  defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool false # Disable the warning when changing a file extension
  defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "2"          # Set sidebar icon size to small
  chflags nohidden ~/Library                                                   # Show the ~/Library folder

  printf "⚙️ Rebuild Launch Services...\n"
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user # Rebuild Launch Services to remove duplicates in the "Open With" menu

  killall Finder

  printf "⚙️ Configure Dock...\n"
  defaults write com.apple.dock "show-recents" -bool true             # Don’t show recent applications in Dock
  defaults write com.apple.dock "orientation" -string "right"         # Set the Dock to the right
  defaults write com.apple.dock "tilesize" -int "36"                  # Set the icon size of Dock items to 36 pixels
  defaults write com.apple.dock "autohide-time-modifier" -float "0.5" # Speed up Mission Control animations
  defaults write com.apple.dock "autohide-delay" -float "2"           # Remove the auto-hiding Dock delay
  defaults write com.apple.dock "mineffect" -string "genie"           # Set the minimize effect to Genie

  killall Dock

  printf "⚙️ Configure Screenshots...\n"
  mkdir ~/Pictures/Screenshots
  defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"
  defaults write com.apple.screencapture type -string "jpg"
  defaults write com.apple.screencapture "disable-shadow" -bool false
  defaults write com.apple.screencapture "include-date" -bool false
  defaults write com.apple.screencapture "show-thumbnail" -bool true

  defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool false

  defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm\""

  killall SystemUIServer

  printf "⚙️ Configure Safari...\n"
  defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true"
  killall Safari

  defaults write NSGlobalDomain com.apple.mouse.scaling -float "1.5"
  defaults write com.apple.Terminal "FocusFollowsMouse" -bool true
  killall Terminal

  defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "2"

  defaults write com.apple.HIToolbox AppleFnUsageType -int "2"
  defaults write NSGlobalDomain com.apple.keyboard.fnState -bool false

  defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"

  defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled -bool "false"

  defaults write com.apple.dock "expose-group-apps" -bool "false"

  killall Dock

  # printf "⚙️ Configure energy saving...\n"
  # sudo pmset -a displaysleep 15
  # sudo pmset -c sleep 0
  # sudo pmset -a hibernatemode 0
}

remove_logs() {
  sudo rm -rf /var/log/*
  printf "Logs removed"
}

flush_dns_cache() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
  printf "DNS cache flushed"
}

enable_firewall() {
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
  printf "Network firewall enabled"
}

function optimize_power() {
  printf "Optimizing power settings..."

  sudo pmset -a displaysleep 15
  sudo pmset -a disksleep 10
  sudo pmset -a womp 1
  sudo pmset -a networkoversleep 0
}

function clear_system_caches() {
  sudo rm -rf ~/Library/Caches/*
  sudo rm -rf /Library/Caches/*
  printf "System caches cleared"
}

function remove_unused_languages() {
  sudo rm -rf /System/Library/CoreServices/Language\ Chooser.app
  printf "Unused languages removed"
}

function clear_font_caches() {
  sudo atsutil databases -remove
  sudo atsutil server -shutdown
  sudo atsutil server -ping
  printf "Font caches cleared"
}

function remove_ds_store_files() {
  find . -name '.DS_Store' -depth -exec rm -f {} \;
  printf "DS_Store files removed"
}

function disable_analytics() {
  brew analytics off
}

enhance_performance() {
  sudo mdutil -d /System/Volumes/Preboot /opt # disable spotlight indexing on both folder
}
