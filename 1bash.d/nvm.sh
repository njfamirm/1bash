# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# auto upgrade to the stable version and migrate Yarn packages
function updateNodeToStable() {
  echo "🚀 Starting update to the latest Current version..."
  nvm install --default
  if [ $? -eq 0 ]; then
    echo "✅ Successfully installed the latest Current version."
  else
    echo "❌ Failed to install the latest Current version."
    return 1
  fi

  nvm alias default stable
  if [ $? -eq 0 ]; then
    echo "✅ Successfully set the default alias to the latest stable version."
  else
    echo "❌ Failed to set the default alias."
    return 1
  fi

  nvm use default
  if [ $? -eq 0 ]; then
    echo "✅ Successfully switched to the default alias."
  else
    echo "❌ Failed to switch to the default alias."
    return 1
  fi

  echo "🎉 Update to the latest stable version completed."
}
