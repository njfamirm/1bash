if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
else
    # if not found in /usr/local/etc, try the brew --prefix location
    if [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
        . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
    fi
fi
