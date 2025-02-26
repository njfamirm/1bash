if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
elif [ -f /etc/bash_completion ]; then # Check system-wide location
  . /etc/bash_completion
elif command -v brew &>/dev/null && [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
  . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
elif [ -f /usr/share/bash-completion/completions/git ]; then
  . /usr/share/bash-completion/completions/git
fi

new_updated_branch() {
  if [ -z "$1" ]; then
    echo "Usage: new_updated_branch <branch_name>"
    return 1
  fi

  git switch next
  git pull --prune --progress --autostash --rebase=true -v
  git switch -c $1
}
